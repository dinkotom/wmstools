require_relative('setup_tests')
require_relative('../server/helpers/helpers_test_case_overview')

class TestCaseOverviewTest < Test::Unit::TestCase
  include HelpersTestCaseOverview

  def setup
    @created_executions = create_test_executions
    create_test_cases
    connect_environments_with_test_cases
    create_test_case_results
    @fat = Environment.get('FAT')
    @fat4 = Environment.get('FAT4')
    @prometera = Environment.get('PROMETERA')
  end

  def create_test_executions
    e1 = TestExecution.new
    e2 = TestExecution.new
    e3 = TestExecution.new
    e4 = TestExecution.new
    e5 = TestExecution.new
    e6 = TestExecution.new
    e1.environment_name, e1.test_suite_name, e1.revision, e1.status = 'FAT4', '[F] WEB SERVICE TESTS', '42614', 'Finished'
    e2.environment_name, e2.test_suite_name, e2.revision, e2.status = 'FAT4', '[F] WEB SERVICE TESTS', '42613', 'Finished'
    e3.environment_name, e3.test_suite_name, e3.revision, e3.status = 'FAT', '[F] WEB SERVICE TESTS', '42612', 'Failed'
    e4.environment_name, e4.test_suite_name, e4.revision, e4.status = 'FAT', '[F] WEB SERVICE TESTS', '42613', 'Failed'
    e5.environment_name, e5.test_suite_name, e5.revision, e5.status = 'FAT', '[F] WEB SERVICE TESTS', '42614', 'Running'
    e6.environment_name, e6.test_suite_name, e6.revision, e6.status = 'FAT4', '[F] SMOKE TESTS', '42614', 'Finished'
    begin
      e1.save
      e2.save
      e3.save
      e4.save
      e5.save
      e6.save
    rescue DataMapper::SaveFailureError => err
      p err.resource.errors.inspect
    end
    [e1, e2, e3, e4, e5, e6]
  end

  def destroy_test_executions
    @created_executions.each { |e| e.destroy! }
  end

  def create_test_cases
    TestCase.destroy!
    TestCase.create(:id => '[TC001]')
    TestCase.create(:id => '[TC002]')
    TestCase.create(:id => '[TC003]')
    TestCase.create(:id => '[TC003W]')
  end

  def create_test_case_results
    TestCaseResult.destroy!
    begin
      TestCaseResult.create(
          :test_case_id => '[TC001]',
          :test_execution_id => @created_executions.first.id,
          :environment_name => @created_executions.first.environment.name,
          :test_suite_name => @created_executions.first.test_suite.name,
          :revision => @created_executions.first.revision,
          :result => 'FAILED',
          :message => 'a')
      TestCaseResult.create(
          :test_case_id => '[TC002]',
          :test_execution_id => @created_executions.first.id,
          :environment_name => @created_executions.first.environment.name,
          :test_suite_name => @created_executions.first.test_suite.name,
          :revision => @created_executions.first.revision,
          :result => 'PASSED',
          :message => 'a')
      TestCaseResult.create(
          :test_case_id => '[TC001]',
          :test_execution_id => @created_executions.last.id,
          :environment_name => @created_executions.last.environment.name,
          :test_suite_name => @created_executions.last.test_suite.name,
          :revision => @created_executions.last.revision,
          :result => 'PASSED',
          :message => 'a')
      TestCaseResult.create(
          :test_case_id => '[TC002]',
          :test_execution_id => @created_executions[2].id,
          :environment_name => @created_executions[2].environment.name,
          :test_suite_name => @created_executions[2].test_suite.name,
          :revision => @created_executions[2].revision,
          :result => 'FAILED',
          :message => 'a')
    rescue DataMapper::SaveFailureError => e
      p e.resource.errors.inspect
    end
  end

  def connect_environments_with_test_cases
    tc1 = TestCase.get('[TC001]')
    tc1.environments << Environment.get('FAT')
    tc1.environments << Environment.get('FAT4')
    tc1.save

    tc2 = TestCase.get('[TC002]')
    tc2.environments << Environment.get('FAT')
    tc2.environments << Environment.get('FAT4')
    tc2.save
  end

  def test_getting_newest_revision
    assert_equal('42613', get_newest_revision(@fat))
    assert_equal('42614', get_newest_revision(@fat4))
  end

  def test_getting_newest_revision_when_no_executions_are_available
    assert_equal('No valid revision found.', get_newest_revision(@prometera))
  end

  def test_getting_test_cases_count
    test_cases = get_test_cases(@fat4, '42614')
    assert_equal(2, test_cases.count)
  end

  def test_getting_test_case_result
    test_cases = get_test_cases(@fat4, '42614')
    assert_equal('FAILED', test_cases[0].result)
    assert_equal('PASSED', test_cases[1].result)
  end

  def test_getting_no_result
    test_cases = get_test_cases(@fat, '42614')
    assert_equal('NO RESULT', test_cases[0].result)
  end

  def teardown
    destroy_test_executions
  end
end