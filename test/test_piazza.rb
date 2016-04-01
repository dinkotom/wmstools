require_relative('setup_tests')

class PiazzaTest < Test::Unit::TestCase
  def setup
    @piazza_data = {:environments =>
                        [{:branch => 'trunk',
                          :name => 'FAT',
                          :result => 'Failure',
                          :running? => true,
                          :suites =>
                              [{:failed => nil,
                                :name => '[F] REGRESSION TESTS 1',
                                :passed => nil,
                                :progress => nil,
                                :result => nil,
                                :revision => nil,
                                :running? => false,
                                :running_result => nil,
                                :total => 30},
                               {:failed => nil,
                                :name => '[F] REGRESSION TESTS 2',
                                :passed => nil,
                                :progress => nil,
                                :result => nil,
                                :revision => nil,
                                :running? => false,
                                :running_result => nil,
                                :total => 30},
                               {:failed => nil,
                                :name => '[F] REGRESSION TESTS 3',
                                :passed => nil,
                                :progress => nil,
                                :result => nil,
                                :revision => nil,
                                :running? => false,
                                :running_result => nil,
                                :total => 30},
                               {:failed => nil,
                                :name => '[F] REGRESSION TESTS 4',
                                :passed => nil,
                                :progress => nil,
                                :result => nil,
                                :revision => nil,
                                :running? => false,
                                :running_result => nil,
                                :total => 30},
                               {:failed => nil,
                                :name => '[F] REGRESSION TESTS 5',
                                :passed => nil,
                                :progress => nil,
                                :result => nil,
                                :revision => nil,
                                :running? => false,
                                :running_result => nil,
                                :total => 30},
                               {:failed => 1,
                                :name => '[F] SMOKE TESTS',
                                :passed => 1,
                                :progress => 95,
                                :result => 'Failure',
                                :revision => '#42157',
                                :running? => true,
                                :running_result => 'Failure',
                                :total => 1},
                               {:failed => nil,
                                :name => '[F] WEB SERVICE TESTS',
                                :passed => nil,
                                :progress => nil,
                                :result => nil,
                                :revision => nil,
                                :running? => false,
                                :running_result => nil,
                                :total => 5}]}],
                    :screen => {:anything_running? => true, :overall_result => 'Failure'}}
  end

  def test_getting_piazza_data
    TestExecution.destroy!
    TestExecution.create(
        :environment_name => 'FAT',
        :test_suite_name => '[F] SMOKE TESTS',
        :status => 'Finished',
        :result => 'FAILED',
        :started_at => DateTime.now - 2,
        :revision => '42157'


    )
    te = TestExecution.create(
        :environment_name => 'FAT',
        :test_suite_name => '[F] SMOKE TESTS',
        :status => 'Running',
        :result => 'FAILED',
        :started_at => DateTime.now - 1,
        :revision => '42157'
    )

    tc = TestCase.create(:id => '[TC001]')
    tc.environments << te.environment
    tc.save

    tc = TestCase.create(:id => '[TC002]')
    tc.environments << te.environment
    tc.save

    TestCaseResult.create(
        :test_execution => te,
        :test_case => tc,
        :environment => te.environment,
        :test_suite => te.test_suite,
        :result => 'PASSED',
        :message => 'Message'

    )

    TestCaseResult.create(
        :test_execution => te,
        :test_case => tc,
        :environment => te.environment,
        :test_suite => te.test_suite,
        :result => 'FAILED',
        :message => 'Message'

    )

    assert_equal(@piazza_data, get_piazza_data(2))
  end

end