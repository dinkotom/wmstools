require 'test/unit'
require_relative('setup_tests')
require_relative('../agent/config/conf_test')

class RollbackRunningExecsTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def setup
    TestExecution.destroy!
    TestCase.destroy!
    @running_execution, @test_case_result, @performance_measurement = create_running_execution
  end

  def test_status_from_running_to_pending
    TestExecution.rollback_running_executions
    assert_equal('Pending', TestExecution.get(@running_execution.id).status)
  end

  def test_status_from_preparing_to_pending
    @running_execution.status = 'Preparing'
    @running_execution.save
    TestExecution.rollback_running_executions
    assert_equal('Pending', TestExecution.get(@running_execution.id).status)
  end

  def test_finished_execs_not_touched
    @running_execution.status = 'Finished'
    @running_execution.save
    TestExecution.rollback_running_executions
    assert_equal('Finished', TestExecution.get(@running_execution.id).status)
  end

  def test_related_test_case_results_deleted
    TestExecution.rollback_running_executions
    assert_equal(TestCaseResult.all(:test_execution => @running_execution).count, 0)
  end

  def test_related_performance_measurements_deleted
    TestExecution.rollback_running_executions
    assert_equal(PerformanceMeasurement.all(:test_execution => @running_execution).count, 0)
  end

  def test_some_fields_are_cleared_out_during_rollback
    TestExecution.rollback_running_executions
    assert_nil(TestExecution.get(@running_execution.id).revision)
    assert_nil(TestExecution.get(@running_execution.id).report)
    assert_nil(TestExecution.get(@running_execution.id).comment)
    assert_nil(TestExecution.get(@running_execution.id).jira_issue)
    assert_nil(TestExecution.get(@running_execution.id).result)
    assert_nil(TestExecution.get(@running_execution.id).started_at)
    assert_nil(TestExecution.get(@running_execution.id).finished_at)
    assert_false(TestExecution.get(@running_execution.id).hidden)
    assert_nil(TestExecution.get(@running_execution.id).agent)
    assert_nil(TestExecution.get(@running_execution.id).pid)
    assert_nil(TestExecution.get(@running_execution.id).exit_code)
    assert_nil(TestExecution.get(@running_execution.id).stderr)
    assert_nil(TestExecution.get(@running_execution.id).output_zip_base64)
  end

  def test_prepare_for_agents_shutdown
    get '/prepare_for_agents_shutdown'
    assert_equal('OK', last_response.body)
  end

  def create_running_execution
    test_execution = TestExecution.new
    test_execution.revision = '54654'
    test_execution.report = 'report'
    test_execution.comment = 'comment'
    test_execution.jira_issue = 'jira issue'
    test_execution.result = 'result'
    test_execution.for = 'for'
    test_execution.status = 'Running'
    test_execution.enqueued_at = DateTime.now
    test_execution.started_at = DateTime.now + 1
    test_execution.finished_at = DateTime.now + 2
    test_execution.agent = 'agent'
    test_execution.pid = 'pid'
    test_execution.exit_code = 1
    test_execution.stderr = 'stderr'
    test_execution.output_zip_base64 = 'zip'
    test_execution.environment = Environment.get('FAT')
    test_execution.test_suite = TestSuite.get('[F] SMOKE TESTS')
    test_execution.delivery_site_type = DeliverySiteType.get('type1')
    test_execution.save

    performance_measurement_point = PerformanceMeasurementPoint.new
    performance_measurement_point.id = PerformanceMeasurementPoint.all.count + 1
    performance_measurement_point.name = 'one'
    performance_measurement_point.test_suite_name = 'FAT'
    performance_measurement_point.save

    performance_measurement = PerformanceMeasurement.new
    performance_measurement.test_execution = test_execution
    performance_measurement.performance_measurement_point = performance_measurement_point
    performance_measurement.save

    test_case = TestCase.new
    test_case.id = 'id'
    test_case.environments << test_execution.environment
    test_case.save

    test_case_result = TestCaseResult.new
    test_case_result.test_execution = test_execution
    test_case_result.test_suite_name = '[F] SMOKE TESTS'
    test_case_result.test_case = test_case
    test_case_result.environment = test_execution.environment
    test_case_result.result = 'result'
    test_case_result.message = 'message'
    test_case_result.save

    return test_execution, test_case_result, performance_measurement
  end
end