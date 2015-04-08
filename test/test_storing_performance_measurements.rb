require_relative('setup_tests')

class StoringPerformanceMeasurementsTest < Test::Unit::TestCase

  def setup


    @stdout = %q{
      [TC005] [P] New delivery site [basic] PASSED for DS 735999102110642463
      [TC023] Hourly collection [basic] PASSED for DS 735999102110642463
      [PERF001][180]
      [TC087] Disconnection no customer [basic] PASSED for DS 735999102110642463
      [PERF001b][10]
      [TC097] New Harley delivery site [basic] PASSED for DS 735999102110642500
      [PERF002][154454]
      [TC102] New Harley delivery site [cancel accept] PASSED for DS 735999102110642524
      [TC098] New Harley delivery site [twoCounter] PASSED for DS 735999102110642555
      [TC005] [P] New delivery site [basic] PASSED for DS 735999102110642593
      [TC094] Termination [notPerformed notFinished] PASSED for DS 735999102110642593
      [TC071] Manual reconnection [basic] PASSED for DS 735999102110642593
      [TC096] AMM meter reading request [cancel triggeredByMoveIn] PASSED for DS 735999102110642593
      [TC079] Manual reconnection [basic RDR SelfReadYes] PASSED for DS 735999102110642593
    }


    @sut = TestExecution.new
    @sut.environment_name = 'FAT'
    @sut.for = 'tomas.dinkov@tieto.com'
    @sut.test_suite_name = '[F] PERFORMANCE TESTS'
    @sut.id = 1
    PerformanceMeasurement.destroy!
  end

  def test_storing_performance_measurements
    @sut.result = 'PASSED'
    @sut.send(:store_performance_measurements, @stdout)
    assert_equal(2, PerformanceMeasurement.all.count)
  end

  def test_not_storing_performance_measurements_when_execution_fails
    @sut.result = 'FAILED'
    @sut.send(:store_performance_measurements, @stdout)
    assert_equal(0, PerformanceMeasurement.all.count)
  end

  def test_not_storing_performance_measurements_on_non_performance_suite
    @sut.result = 'PASSED'
    @sut.test_suite_name = '[F] REGRESSION TESTS 1'
    @sut.send(:store_performance_measurements, @stdout)
    assert_equal(0, PerformanceMeasurement.all.count)
  end
end