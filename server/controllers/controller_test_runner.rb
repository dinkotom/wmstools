require_relative('../helpers/helpers_test_runner')
include HelpersTestRunner

get '/test_runner' do
  @test_executions = TestExecution.all(:hidden => false, :limit => NO_SHOWN_ITEMS, :order => [:enqueued_at.desc])
  @environments = Environment.all
  @test_suites = TestSuite.all(:order => [:priority])

  @test_suites_filter = TestExecution.all(:hidden => false, :fields => [:test_suite_name], :unique => true, :order => [:test_suite_name.desc])
  @environments_filter = TestExecution.all(:hidden => false, :fields => [:environment_name], :unique => true, :order => [:environment_name.asc])

  erb :test_runner
end

get '/test_runner/:id' do
  test_execution = TestExecution.get(params[:id])

  if test_execution
    @test_report = test_execution.report.gsub(/\n/, "<BR>\n") if test_execution.report
    @test_result = test_execution.result if test_execution.respond_to?('result')
    @comment = test_execution.comment if test_execution.respond_to?('comment')
    @jira_issue = test_execution.jira_issue if test_execution.respond_to?('jira_issue')
    if @jira_issue then
      jira = Jira.new
      response = jira.get(@jira_issue)
      if is_json?(response) then
        @jira_issue_status = JSON.parse(response)['fields']['status']['name']
      else
        @jira_issue_status = 'Unknown'
      end
    end
    revision_to = test_execution.revision
    time_of_this_test_result = test_execution.started_at
    previous_execution = TestExecution.all(:environment_name => test_execution.environment_name,
                                           :started_at.lt => time_of_this_test_result,
                                           :revision.not => 'Revision not found',
                                           :revision.not => test_execution.revision,
                                           :order => [:started_at.desc]).first
    revision_from = previous_execution.revision if previous_execution.respond_to?('revision')
    svn = Svn.new
    svn.revision_from = revision_from
    svn.revision_to = revision_to
    svn.branch = WmsVersion.get(Environment.get(test_execution.environment_name).wms_version_name).svn_branch
    @svn_log = svn.svn_log

    erb :test_report
  else
    "Test execution #{params[:id]} does not exist."
  end

end

get '/test_runner/:id/download_log' do
  download_log(params[:id])
end

post '/test_runner/table_data' do

  if params[:test_suite] == "false" then
    params[:test_suite] = false
  end
  if params[:environment] == "false" then
    params[:environment] = false
  end

  return get_table_data(Integer(params[:items]), Integer(params[:page]), params[:test_suite], params[:environment]).to_json
end

# post '/test_runner/piazza_ajax' do
#   get_environment_test_results(Environment.all).to_json
# end

post '/test_runner/enqueue' do
  enqueue_package(params[:test_suite_name], params[:environment], params[:for]) ? '1' : '0'
end

post '/test_runner/:id/remove_ajax' do
  begin
    TestExecution.get(params[:id]).destroy
  rescue DataMapper::SaveFailureError => e
    $logger.error(e.resource.errors.inspect)
    return '0'
  end
  return '1'
end

post '/test_runner/:id/kill' do
  set_to_pending_kill(params[:id]) ? '1' : '0'
end


post '/test_runner/:id/hide_ajax' do
  test_execution = TestExecution.get(params[:id])
  test_execution.hidden = true
  begin
    test_execution.save
  rescue DataMapper::SaveFailureError => e
    $logger.error(e.resource.errors.inspect)
    return '0'
  end
  return '1'
end

get '/test_runner/:id/get_comment' do
  return TestExecution.get(params[:id]).comment
end

post '/test_runner/:id/save_comment' do
  test_execution = TestExecution.get(params[:id])
  test_execution.comment = params[:comment]
  begin
    test_execution.save
  rescue DataMapper::SaveFailureError => e
    $logger.error(e.resource.errors.inspect)
    return '0'
  end
  return '1'
end

post '/test_runner/:id/create_issue_ajax' do
  return create_jira.to_json
end

post '/test_runner/test_suites' do
  multiples, singles = get_packages_for_environment(params[:environment])

  case params[:scope]
    when 'single'
      singles.to_json
    when 'package'
      multiples.to_json
  end
end