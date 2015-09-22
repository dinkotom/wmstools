require_relative('./integration.rb')
require_relative('./helpers/helpers_test_case_overview.rb')

include HelpersTestCaseOverview



thread = Thread.new do
  scheduler = Rufus::Scheduler.new

  if defined? FORTUM_TRUNK_REGRESSION_TESTS_JOB
    begin
      scheduler.cron FORTUM_TRUNK_REGRESSION_TESTS_JOB[:cron] do
        FORTUM_TRUNK_REGRESSION_TESTS_JOB[:suites_environments].each do |job|
          test_execution = TestExecution.new
          test_execution.test_suite_name = job[:suite]
          test_execution.environment_name = job[:environment]
          test_execution.for = 'SCHEDULER'
          test_execution.enqueue
        end
      end
    end
  end

  if defined? FORTUM_BRANCH_REGRESSION_TESTS_JOB
    begin
      scheduler.cron FORTUM_BRANCH_REGRESSION_TESTS_JOB[:cron] do
        FORTUM_BRANCH_REGRESSION_TESTS_JOB[:suites_environments].each do |job|
          test_execution = TestExecution.new
          test_execution.test_suite_name = job[:suite]
          test_execution.environment_name = job[:environment]
          test_execution.for = 'SCHEDULER'
          test_execution.enqueue
        end
      end
    end
  end

  if defined? PROMETERA_REGRESSION_TESTS_JOB
    begin
      scheduler.cron PROMETERA_REGRESSION_TESTS_JOB[:cron] do
        PROMETERA_REGRESSION_TESTS_JOB[:suites_environments].each do |job|
          test_execution = TestExecution.new
          test_execution.test_suite_name = job[:suite]
          test_execution.environment_name = job[:environment]
          test_execution.for = 'SCHEDULER'
          test_execution.enqueue
        end
      end
    end
  end
  
    if defined? PROMETERA_BRANCH_TESTS_JOB
    begin
      scheduler.cron PROMETERA_BRANCH_TESTS_JOB[:cron] do
        PROMETERA_BRANCH_TESTS_JOB[:suites_environments].each do |job|
          test_execution = TestExecution.new
          test_execution.test_suite_name = job[:suite]
          test_execution.environment_name = job[:environment]
          test_execution.for = 'SCHEDULER'
          test_execution.enqueue
        end
      end
    end
  end

  if defined? FORTUM_SMOKE_TESTS_JOB
    begin
      scheduler.cron FORTUM_SMOKE_TESTS_JOB[:cron] do
        FORTUM_SMOKE_TESTS_JOB[:suites_environments].each do |job|
          test_execution = TestExecution.new
          test_execution.test_suite_name = job[:suite]
          test_execution.environment_name = job[:environment]
          test_execution.for = 'SCHEDULER'
          test_execution.enqueue
        end
      end
    end
  end

  if defined? FORTUM_PERFORMANCE_TESTS_JOB
    begin
      scheduler.cron FORTUM_PERFORMANCE_TESTS_JOB[:cron] do
        FORTUM_PERFORMANCE_TESTS_JOB[:suites_environments].each do |job|
          test_execution = TestExecution.new
          test_execution.test_suite_name = job[:suite]
          test_execution.environment_name = job[:environment]
          test_execution.for = 'SCHEDULER'
          test_execution.enqueue
        end
      end
    end
  end

    if defined? SKAGERAK_TRUNK_REGRESSION_TESTS_JOB
    begin
      scheduler.cron SKAGERAK_TRUNK_REGRESSION_TESTS_JOB[:cron] do
        SKAGERAK_TRUNK_REGRESSION_TESTS_JOB[:suites_environments].each do |job|
          test_execution = TestExecution.new
          test_execution.test_suite_name = job[:suite]
          test_execution.environment_name = job[:environment]
          test_execution.for = 'SCHEDULER'
          test_execution.enqueue
        end
      end
    end
  end
  
      if defined? SKAGERAK_BRANCH_REGRESSION_TESTS_JOB
    begin
      scheduler.cron SKAGERAK_BRANCH_REGRESSION_TESTS_JOB[:cron] do
        SKAGERAK_BRANCH_REGRESSION_TESTS_JOB[:suites_environments].each do |job|
          test_execution = TestExecution.new
          test_execution.test_suite_name = job[:suite]
          test_execution.environment_name = job[:environment]
          test_execution.for = 'SCHEDULER'
          test_execution.enqueue
        end
      end
    end
  end
  
      if defined? FORTUM_LOAD_TESTS_JOB
    begin
      scheduler.cron FORTUM_LOAD_TESTS_JOB[:cron] do
        FORTUM_LOAD_TESTS_JOB[:suites_environments].each do |job|
          test_execution = TestExecution.new
          test_execution.test_suite_name = job[:suite]
          test_execution.environment_name = job[:environment]
          test_execution.for = 'SCHEDULER'
          test_execution.enqueue
        end
      end
    end
  end
  

  scheduler.every CHECK_DELIVERY_SITES_COUNT_EVERY, :first_at => Time.now + 2 do
    DeliverySite.check_storage
  end

  scheduler.join
end
