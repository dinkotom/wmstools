require_relative('setup_tests')
require_relative('../agent/operating_system')
require_relative('../agent/config/conf_test')

class RunningTestExecutionTest < Test::Unit::TestCase

  def setup
    @os = OperatingSystem.new

    @sut = TestExecution.new
    @sut.environment_name = 'FAT'
    @sut.for = 'tomas.dinkov@tieto.com'
    @sut.test_suite_name = '[F] PERFORMANCE TESTS'
    @sut.save
  end

  def test_sending_email
    omit('Omitted for compatibility with Windows TeamCity Agent') unless RUBY_PLATFORM =~ /linux/
    Mail::TestMailer.deliveries.clear
    @sut.report = 'fake report'
    @sut.run(@os)
    assert Mail::TestMailer.deliveries.first
  end

end