require_relative('../../server/helpers/helpers_test_report')
include HelpersTestReport



get '/test_report/:id' do
  te = TestExecution.get(params[:id])
  if te
    @duration = get_duration(te)
    @id = te.id
    @status = te.status
    @failed_test_cases = TestCaseResult.all(:test_execution => {:id => te.id}, :result => 'FAILED').collect {|tcr|tcr.message }
    @passed_test_cases = TestCaseResult.all(:test_execution => {:id => te.id}, :result => 'PASSED').collect {|tcr|tcr.message }
    erb :report, :layout => false
  else
    "Test Execution id #{params[:id]} does not exist."
  end
end

get '/test_report/:id/status' do
  te = TestExecution.get(params[:id])
  if te
    te.status
  else
    "Test Execution id #{params[:id]} does not exist."
  end
end