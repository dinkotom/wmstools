Bundler.require(:test)
require_relative('setup_tests')
require_relative('../agent/operating_system')


class TestCasesTest < Test::Unit::TestCase

  def setup
    @stdout = %q{
      [TC005] [P] New delivery site [basic] PASSED for DS 735999102110642463
      [TC023W] Hourly collection [basic] PASSED for DS 735999102110642463
    }

    @stdout2 = @stdout + %q{
      [TC006] [P] New delivery site [basic] FAILED for DS 735999102110642463
    }


    @stdout3 = @stdout + %q{
      [TC006] [P] New delivery site [basic] FAILED for DS 735999102110642463
      [TC024] Hourly collection [basic] FAILED for DS 735999102110642463
    }

    @stdout4 = @stdout + %q{
      [TC005] [P] New delivery site [basic] FAILED for DS 735999102110642463
      [TC005] [P] New delivery site [basic] PASSED for DS 735999102110642463
    }

    @stdout5 = @stdout + %q{
      [TC006] [P] New delivery site [basic] PASSED for DS 735999102110642463
    }

    @os = OperatingSystem.new
    @os.folder, @os.branch, @os.project_file, @os.suite = 'output', 'trunk', 'WMS.xml', '[F] SMOKE TESTS'

    @te = TestExecution.new
    @te.test_suite_name = '[F] SMOKE TESTS'
    @te.environment_name = 'FAT'
    @te.for = 'TEST'
    @te.revision = '41597'
    @te.enqueue

    TestCase.destroy!
    TestCaseResult.destroy!
  end

  def test_storing_test_case_name
    @stdout.each_line {|line|@os.send(:scan_for_test_cases, line, @te)}
    assert_equal('[P] New delivery site [basic]', TestCase.get('[TC005]').name)
  end

  def test_creating_new_test_cases
    @stdout.each_line {|line|@os.send(:scan_for_test_cases, line, @te)}
    assert_equal(2, TestCase.all.count)
  end

  def test_associating_test_case_with_environments
    @stdout.each_line {|line|@os.send(:scan_for_test_cases, line, @te)}
    assert_equal('FAT', TestCase.all.first.environments.first.name)

    @te = TestExecution.new
    @te.test_suite_name = '[F] SMOKE TESTS'
    @te.environment_name = 'FAT4'
    @te.for = 'TEST'
    @te.revision = '41597'
    @te.enqueue

    @stdout.each_line {|line|@os.send(:scan_for_test_cases, line, @te)}
    assert_equal(['FAT', 'FAT4'], TestCase.all.last.environments.collect {|a|a.name})
  end

  def test_processing_existing_test_cases
    @stdout.each_line {|line|@os.send(:scan_for_test_cases, line, @te)}
    @stdout2.each_line {|line|@os.send(:scan_for_test_cases, line, @te)}
    assert_equal(3, TestCase.all.count)
  end

  def test_storing_test_case_results
    @stdout3.each_line {|line|@os.send(:scan_for_test_cases, line, @te)}
    assert_equal(2, TestCaseResult.all(:test_execution_id => @te.id, :result => 'PASSED').count)
    assert_equal(2, TestCaseResult.all(:test_execution_id => @te.id, :result => 'FAILED').count)
  end

  def test_storing_test_case_message

    @stdout3.each_line {|line|@os.send(:scan_for_test_cases, line, @te)}
    assert_equal("[TC005] [P] New delivery site [basic] PASSED for DS 735999102110642463\n",
                 TestCaseResult.all(:test_execution_id => @te.id, :test_case => {:id => '[TC005]'}).first.message)
  end
end





