require_relative('setup_tests')

class TestRunnerHelperTest < Test::Unit::TestCase
  include HelpersTestRunner

  def setup
    @test_execution = TestExecution.new
    @test_execution.test_suite_name = '[F] SMOKE TESTS'
    @test_execution.environment_name = 'FAT'
    @test_execution.for = 'TEST'
    @test_execution.agent = 'uw001685'
    @test_execution.enqueue
  end

  def test_setting_pending_kill
    @test_execution.status = 'Running'
    @test_execution.save
    set_to_pending_kill(@test_execution.id)
    assert_equal('Pending kill', TestExecution.get(@test_execution.id).status)
  end

  def test_pending_kill_on_non_running_test
    @test_execution.status = 'Finished'
    @test_execution.save
    assert_raise ArgumentError do
      set_to_pending_kill(@test_execution.id)
    end
  end

  def test_downloading_log_on_unfinished_test
    @test_execution.status = 'Running'
    @test_execution.save
    assert_raise ArgumentError do
      download_log(@test_execution.id)
    end
  end

end