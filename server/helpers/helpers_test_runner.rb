require 'base64'

module HelpersTestRunner
  include Rack::Utils
  alias_method :h, :escape_html

  def set_to_pending_kill(test_execution_id)
    te = TestExecution.get(test_execution_id)
    if te.status == 'Running'
      te.status = 'Pending kill'
      te.save
    else
      raise ArgumentError
    end
    true
  end

  def download_log(test_execution_id)
    te_status = TestExecution.get(test_execution_id).status
    if te_status == 'Finished' || te_status == 'Failed'
      Dir.mkdir('./tmp') unless File.exists?('./tmp')
      file = File.open("./tmp/#{params[:id]}.zip", 'w')
      file.write(Base64.decode64(TestExecution.get(params[:id]).output_zip_base64))
      file.close
      send_file file.path, :filename => file.path.split('/').last, :type => 'Application/octet-stream'
    else
      raise ArgumentError
    end
  end

  def save_comment(id, comment)
    comment = String.new if not comment
    test_execution = TestExecution.get(id)
    begin
      test_execution.update(:comment => comment)
    rescue DataMapper::SaveFailureError => e
      $logger.error(e.resource.errors.inspect)
    end
  end

  def is_json? (string)
    JSON.parse(string)
    true
  rescue
    false
  end

  def get_table_data(items, page, test_suite, environment)

    ret_array = Array.new

    case
      when (!test_suite and !environment)

        test_executions = TestExecution.all(
            :hidden => false,
            :offset => ((items * page) - items),
            :limit => items,
            :order => [:enqueued_at.desc]
        )

        execs_count = TestExecution.all(:hidden => false).count.to_s()

      when (!test_suite and environment)

        test_executions = TestExecution.all(
            :hidden => false,
            :offset => ((items * page) - items),
            :limit => items,
            :order => [:enqueued_at.desc],
            :environment_name => environment
        )

        execs_count = TestExecution.all(:hidden => false, :environment_name => environment).count.to_s()

      when (test_suite and !environment)

        test_executions = TestExecution.all(
            :hidden => false,
            :offset => ((items * page) - items),
            :limit => items,
            :order => [:enqueued_at.desc],
            :test_suite_name => test_suite
        )

        execs_count = TestExecution.all(:hidden => false, :test_suite_name => test_suite).count.to_s()

      when (test_suite and environment)

        test_executions = TestExecution.all(
            :hidden => false,
            :offset => ((items * page) - items),
            :limit => items,
            :order => [:enqueued_at.desc],
            :test_suite_name => test_suite,
            :environment_name => environment
        )

        execs_count = TestExecution.all(:hidden => false, :test_suite_name => test_suite, :environment_name => environment).count.to_s()

    end

    test_executions.each do |t|

      started_at = ""
      if t.started_at then
        started_at = t.started_at.strftime('%Y-%m-%d - %H:%M')
      end

      jira = ""
      if t.jira_issue then
        jira = Utils.new.to_link(JIRA_BASE_PATH, t.jira_issue)
      end

      agent = t.agent

      if t.revision == 'Revision not found' then
        t.revision = 'Not found'
      end

      row = {"started_at" => started_at,
             "_for" => t.for,
             "test_suite_name" => t.test_suite_name,
             "environment_name" => t.environment_name,
             "failed_tests" => TestCaseResult.all(:test_execution_id => t.id, :result => 'FAILED').count,
             "passed_tests" => TestCaseResult.all(:test_execution_id => t.id, :result => 'PASSED').count,
             "status" => t.status,
             "node_id" => agent,
             "result" => t.result,
             "revision" => t.revision,
             "id" => t.id,
             "comment" => t.comment,
             "duration" => (((t.finished_at - t.started_at)*24*60).to_i if t.finished_at && t.started_at),
             "jira_issue" => jira
      }
      ret_array << row
    end

    ret_array << {"items_count" => execs_count}
    return ret_array
  end

  def create_jira
    save_comment(params[:id], params[:comment])
    test_execution = TestExecution.get(params[:id])
    jira_issue = test_execution.jira_issue
    if not jira_issue then
      revision = test_execution.revision

      description = <<eos
Comment
=======
#{ test_execution.comment.length > 0 ? test_execution.comment : 'No comment.'}

Report
======
#{test_execution.report}
eos

      summary = "Regression test failed on WMS revision ##{revision}"
      version = WmsVersion.get(Environment.get(test_execution.environment_name).wms_version_name).jira_name
      jira = Jira.new
      issue_content = jira.format_issue_content("MAIN", "Bug", summary, "Regression", description, version)
      response = jira.post(issue_content)
      if response then
        @jira_issue = JSON.parse(response)["key"]
        test_execution.update(:jira_issue => @jira_issue)
        @jira_issue_created = 1 # issue created successfully
        jira.attach(test_execution.path_to_zipped_log, @jira_issue) if test_execution.path_to_zipped_log
      else
        @jira_issue_created = 0 # issue creation failed for unknown reason
      end
    else
      @jira_issue_created = -1 # issue creation failed because it already exists for this test result
      @jira_issue = jira_issue
    end

    if @jira_issue_created == 1 then
      response = jira.get(@jira_issue)
      jira_status = JSON.parse(response)['fields']['status']['name']
      return {"result" => 1, "msg" => Utils.new.to_link(JIRA_BASE_PATH, @jira_issue), "status" => jira_status}
    elsif @jira_issue_created == 0 then
      return {"result" => 0, "msg" => "Issue has not been created!!!"}
    else
      return {"result" => 0, "msg" => "Issue " + @jira_issue + " already exist for test result " + params[:id]}
    end
  end

  def enqueue_package(test_package_name, environment_name, email)
    success = false
    TestPackage.get(test_package_name).test_suites(:order => [:priority.asc]).each do |test_suite|
      test_suite.environments.each do |environment|
        if environment.name == environment_name
          test = TestExecution.new
          test.test_suite_name = test_suite.name
          test.environment_name = environment_name
          test.for = email
          success = true if test.enqueue
        end
      end
    end
    success
  end

  def get_packages_for_environment(environment_name)
    singles = Array.new
    multiples = Array.new
    packages = TestPackage.all.sort { |a, b| a.test_suites.first.priority <=> b.test_suites.first.priority }
    packages.each do |package|
      package_environments = Array.new
      package.test_suites.each do |suite|
        suite_environments = Array.new
        suite.environments.each do |environment|
          suite_environments << environment.name
        end
        package_environments += suite_environments
      end
      singles << {'value' => package.name} if package.test_suites.count == 1 && package_environments.include?(environment_name)
      multiples << {'value' => package.name} if package.test_suites.count > 1 && package_environments.include?(environment_name)
    end
    return multiples, singles
  end
end