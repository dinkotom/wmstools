get '/prepare_for_agent_shutdown' do
  begin
    TestExecution.rollback_running_executions
    p 'OK'
  rescue
    p 'Rollback running executions failed!'
  end
end