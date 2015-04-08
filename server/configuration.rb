class Configuration

  def self.validate
    @@suites = TEST_SUITES.collect { |a| a[:name] }
    @@environments = ENVIRONMENTS.collect { |a| a[:name] }

    @@failure = false
    validate_fortum_regression_test_jobs
    validate_test_suites
    validate_packages

    abort if @@failure
  end

  def self.validate_fortum_regression_test_jobs
    if defined? FORTUM_REGRESSION_TESTS_JOB
      FORTUM_REGRESSION_TESTS_JOB[:suites_environments].each do |suite_env|
        unless @@suites.include?(suite_env[:suite])
          p 'STARTUP ERROR: ' + __method__.to_s + ": suite '#{suite_env[:suite]}' is not defined."
          @@failure = true
        end
        unless @@environments.include?(suite_env[:enviroment])
          p 'STARTUP ERROR: ' + __method__.to_s + ": environment '#{suite_env[:enviroment]}' is not defined."
          @@failure = true
        end
      end
    end
  end

  def self.validate_test_suites
    unless defined? TEST_SUITES
      p 'STARTUP ERROR: ' + __method__.to_s + ': TEST SUITES are not defined.'
      @@failure = true
    end
    if defined? TEST_SUITES
      TEST_SUITES.each do |ts|
        unless @@environments | ts[:environments] == @@environments
          p 'STARTUP ERROR: ' + __method__.to_s + ": environment '#{(@@environments | ts[:environments]) - @@environments }' is not defined."
          @@failure = true
        end
      end
    end
  end

  def self.validate_packages
    unless defined? TEST_PACKAGES
      p 'STARTUP ERROR: ' + __method__.to_s + ': TEST PACKAGES are not defined.'
      @@failure = true
    end
    if defined? TEST_PACKAGES
      TEST_PACKAGES.each do |package|
        unless @@suites | package[:suites] == @@suites
          p 'STARTUP ERROR: ' + __method__.to_s + ": test suite '#{(@@suites | package[:suites]) - @@suites}' is not defined."
          @@failure = true
        end
      end
    end
  end

end