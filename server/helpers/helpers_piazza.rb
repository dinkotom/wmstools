module HelpersPiazza
  def get_piazza_data(screen_id)
    piazza_data = Hash.new
    piazza_data[:screen] = Hash.new
    piazza_data[:screen][:anything_running?] = anything_running?(screen_id)
    piazza_data[:screen][:overall_result] = get_overall_result(screen_id)
    piazza_data[:environments] = Array.new
    screen = get_piazza_screen(screen_id)
    screen.environments.each do |environment|
      environment_data = get_environment_data_hash(environment)
      piazza_data[:environments] << environment_data
    end if screen
    piazza_data
  end

  def get_overall_result(screen_id)
    result = 'Success'
    screen = get_piazza_screen(screen_id)
    if screen
      screen.environments.each do |environment|
        result = 'Failure' if get_environment_result(environment) == 'Failure'
      end
    end
    result
  end

  def anything_running?(screen_id)
    result = false
    screen = get_piazza_screen(screen_id)
    if screen
      screen.environments.each do |environment|
        result = true if is_running?(environment)
      end
    end
    result
  end

  def get_piazza_screen(screen_id)
    begin
      PiazzaScreen.get(screen_id)
    rescue ArgumentError
      message = "Piazza screen with id #{screen_id} does not exist"
      p message
      $logger.error(message)
      false
    end
  end

  def get_environment_data_hash(environment)
    environment_data = Hash.new
    environment_data[:branch] = environment.wms_version.svn_branch
    environment_data[:name] = environment.name
    environment_data[:result] = get_environment_result(environment)
    environment_data[:running?] = is_running?(environment)
    environment_data[:suites] = get_suite_details(environment)

    environment_data
  end

  def get_environment_result(environment)
    results_per_suite = Array.new
    get_suites(environment).each do |ts|
      last_finished_execution = TestExecution.all(
          :environment_name => environment.name,
          :test_suite_name => ts.name,
          :status => 'Finished',
          :order => [:started_at.asc]
      ).last
      results_per_suite << last_finished_execution.result if last_finished_execution
    end
    results_per_suite.include?('FAILED') ? 'Failure' : 'Success'
  end

  def get_suites(environment)
    TestSuite.all(:piazza => true).select { |ts| ts.environments.include?(environment) }
  end

  def is_running?(environment)
    running = false
    get_suites(environment).each do |suite|
      running_executions = TestExecution.all(:test_suite => suite, :environment => environment, :status => 'Running')
      running = true if running_executions.count > 0
    end
    running
  end

  def get_suite_details(environment)
    suites = Array.new
    get_suites(environment).each do |suite|
      suite_details = Hash.new
      suite_details[:name] = suite.name
      suite_details[:revision] = get_last_revision(environment, suite)
      suite_details[:result] = get_result(environment, suite)
      suite_details[:running?] = get_running(environment, suite)
      suite_details[:total] = suite.default_number_of_tests
      suite_details[:passed] = get_passed(environment, suite)
      suite_details[:failed] = get_failed(environment, suite)
      suite_details[:progress] = get_progress(suite_details[:passed], suite_details[:failed], suite_details[:total])
      suite_details[:running_result] = get_running_result(suite_details[:failed])
      suites << suite_details
    end
    suites
  end

  def get_last_revision(environment, suite)
    last = TestExecution.all(
        :environment => environment,
        :test_suite => suite,
        :order => [:started_at.asc]
    ).select { |te| te.revision.match('\d{5}') if te.revision }.last
    '#' + last.revision if last
  end

  def get_result(environment, suite)
    last_finished = TestExecution.all(
        :environment => environment,
        :test_suite => suite,
        :order => [:started_at.asc],
        :status => 'Finished'
    ).last
    last_finished ? last_finished_result = last_finished.result : last_finished_result = nil
    if last_finished_result
      if last_finished_result == 'PASSED'
        return 'Success'
      else
        return 'Failure'
      end
    end
  end

  def get_running(environment, suite)
    running_execs = TestExecution.all(:environment => environment, :test_suite => suite, :status => 'Running')
    if running_execs.count > 0
      return true
    else
      return false
    end
  end

  def get_passed(environment, suite)
    last_running_exec = TestExecution.all(
        :environment => environment,
        :test_suite => suite,
        :status => 'Running',
        :order => [:started_at.asc]
    ).last
    last_running_exec.test_case_results.select { |tcr| tcr.result == 'PASSED' }.count if last_running_exec
  end


  def get_failed(environment, suite)
    last_running_exec = TestExecution.all(
        :environment => environment,
        :test_suite => suite,
        :status => 'Running',
        :order => [:started_at.asc]
    ).last
    last_running_exec.test_case_results.select { |tcr| tcr.result == 'FAILED' }.count if last_running_exec
  end

  def get_progress(passed_count, failed_count, total_count)
    progress = nil
    if passed_count.kind_of?(Integer) && failed_count.kind_of?(Integer) && total_count.kind_of?(Integer)
      progress = (((passed_count + failed_count)*100)/total_count.to_f).round(0)
      progress = 95 if progress > 99
    end
    progress
  end

  def get_running_result(failed_count)
    failed_count > 0 ? 'Failure' : 'Success' if failed_count.kind_of?(Integer)
  end
end