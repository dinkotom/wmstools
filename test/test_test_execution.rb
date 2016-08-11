require 'test/unit'
require_relative('setup_tests')
require_relative('../agent/config/conf_test')


class TestExecutionTest < Test::Unit::TestCase

#  def setup
#    TestExecution.destroy!
#
#    @os = mock
#  end
#
#  def test_setting_status_finished
#    test_execution = TestExecution.new
#    test_execution.test_suite_name = '[F] SMOKE TESTS'
#    test_execution.environment_name = 'FAT'
#    test_execution.for = 'TEST'
#    test_execution.agent = 'uw001685'
#    test_execution.enqueue
#
#    @os.expects(:folder=).returns(test_execution.id)
#    @os.expects(:project_file=).returns('WMS.xml')
#    @os.expects(:suite=).returns('[F] SMOKE TESTS')
#    @os.expects(:branch=).returns('trunk')
#    @os.expects(:environment=).returns('FAT')
#    @os.expects(:run, test_execution).returns('Finished')
#    @os.expects(:exit_status, test_execution).returns(0)
#    @os.expects(:stderr).at_least_once.returns('')
#
#    TestExecution.dequeue(@os)
#
#    assert_equal(1, TestExecution.all(:status => 'Finished').count)
#  end
#
#  def test_stop_dequeuing_when_reaching_quota_of_5_on_this_agent
#
#    # enqueue 1 execution, dequeue it and the move it to a foreign agent
#    test_execution = TestExecution.new
#    test_execution.test_suite_name = '[F] SMOKE TESTS'
#    test_execution.environment_name = 'FAT'
#    test_execution.for = 'TEST'
#    test_execution.enqueue
#
#    @os.expects(:folder=).returns(test_execution.id)
#    @os.expects(:project_file=).returns('WMS.xml')
#    @os.expects(:suite=).returns('[F] SMOKE TESTS')
#    @os.expects(:environment=).returns('FAT')
#    @os.expects(:branch=).returns('trunk')
#    @os.expects(:run, test_execution).returns('Running')
#    @os.expects(:exit_status).returns(0)
#    @os.expects(:stderr).at_least_once.returns('')
#
#    TestExecution.dequeue(@os)
#
#    test_execution.agent = 'uw001686'
#    begin
#      test_execution.save
#    rescue DataMapper::SaveFailureError => e
#      p e.resource.errors.inspect
#    end
#    # comment end
#
#    # enqueue 5 executions and dequeue them on this agent - all should dequeue as executions running on foreign agent should not count to quota
#    5.times do
#      test_execution = TestExecution.new
#      test_execution.test_suite_name = '[F] SMOKE TESTS'
#      test_execution.environment_name = 'FAT'
#      test_execution.for = 'TEST'
#      test_execution.enqueue
#
#      @os.expects(:folder=).returns(test_execution.id)
#      @os.expects(:project_file=).returns('WMS.xml')
#      @os.expects(:suite=).returns('[F] SMOKE TESTS')
#      @os.expects(:branch=).returns('trunk')
#      @os.expects(:environment=).returns('FAT')
#      @os.expects(:run, test_execution).returns('Running')
#      @os.expects(:exit_status).returns(0)
#      @os.expects(:stderr).returns('')
#
#      TestExecution.dequeue(@os)
#    end
#    # comment end
#
#    # enqueue 1 more execution and attempt to dequeue it on this agent - it should not dequeue as quota for this agent has already been reached
#    test_execution = TestExecution.new
#    test_execution.test_suite_name = '[F] SMOKE TESTS'
#    test_execution.environment_name = 'FAT'
#    test_execution.for = 'TEST'
#    test_execution.enqueue
#
#    @os.expects(:run, test_execution).never
#
#    TestExecution.dequeue(@os)
#    # comment end
#  end
#
#  def test_not_dequeuing_when_preparing
#    test_execution = TestExecution.new
#    test_execution.test_suite_name = '[F] SMOKE TESTS'
#    test_execution.environment_name = 'FAT'
#    test_execution.agent = THIS_AGENT_ID
#    test_execution.for = 'TEST'
#    test_execution.enqueue
#
#    test_execution.status = 'Preparing'
#    test_execution.save
#
#    @os.expects(:run, test_execution).never
#    TestExecution.dequeue(@os)
#  end

end