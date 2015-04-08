require_relative('setup_tests')

class EvaluateResultTest < Test::Unit::TestCase
  def setup
    @te = TestExecution.new
    @te.environment_name = 'FAT'
    @te.test_suite_name = '[F] SMOKE TESTS'
    @te.save

    @tc1 = TestCase.new
    @tc1.id = '[TC001]'
    @tc1.save

    @tc2 = TestCase.new
    @tc2.id = '[TC002]'
    @tc2.save
  end

  def test_no_result
    assert_equal('No result', @te.send(:evaluate_result))
  end

  def test_passed
    @tcr1 = TestCaseResult.new
    @tcr1.test_execution_id = @te.id
    @tcr1.test_case_id = @tc1.id
    @tcr1.environment = @te.environment
    @tcr1.test_suite = @te.test_suite
    @tcr1.message = 'message'
    @tcr1.result = 'PASSED'
    @tcr1.save

    assert_equal('PASSED', @te.send(:evaluate_result))
  end

  def test_failed
    @tcr1 = TestCaseResult.new
    @tcr1.test_execution_id = @te.id
    @tcr1.test_case_id = @tc1.id
    @tcr1.environment = @te.environment
    @tcr1.test_suite = @te.test_suite
    @tcr1.message = 'message'
    @tcr1.result = 'PASSED'
    @tcr1.save

    @tcr2 = TestCaseResult.new
    @tcr2.test_execution_id = @te.id
    @tcr2.test_case_id = @tc1.id
    @tcr2.environment = @te.environment
    @tcr2.test_suite = @te.test_suite
    @tcr2.message = 'message'
    @tcr2.result = 'FAILED'
    @tcr2.save

    assert_equal('FAILED', @te.send(:evaluate_result))
  end

  def teardown
    @te.destroy!
    @tc1.destroy!
    @tc2.destroy!
    @tcr1.destroy! if @tcr1
    @tcr2.destroy! if @tcr2
  end
end