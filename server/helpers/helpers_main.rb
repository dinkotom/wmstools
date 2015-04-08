module HelpersMain
  include Rack::Utils
  alias_method :h, :escape_html



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
end