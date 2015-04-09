module HelpersTestCaseOverview
  def get_newest_revision(environment)
    if environment.respond_to?(:name)
      executions = TestExecution.all(:environment_name => environment.name).collect do |e|
        e if e.revision =~ /\d{5,7}/ && e.status != 'Running'
      end.compact
      if executions.count > 0
        executions.sort do |a, b|
          a.revision <=> b.revision
        end.last.revision
      else
        'No valid revision found.'
      end
    else
      'Invalid environment object.'
    end

  end

  def get_test_cases(environment, revision)
    TestCase.all.select { |tc| tc.environments.get(environment.name) }.each do |a|
      test_case_results = TestExecution.all(:environment_name => environment.name, :revision => revision).collect do |b|
        test_case_result = TestCaseResult.all(
            :revision => revision,
            :test_case_id => a.id,
            :environment_name => b.environment_name,
            :test_suite_name => b.test_suite_name,
            :order => [:id.asc]
        ).first
        test_case_result.result if test_case_result
      end.compact
      case
        when test_case_results.include?('FAILED')
          a.result = 'FAILED'
          a.define_singleton_method(:class) do
            'element-item failed '
          end
        when test_case_results.size > 0 && !test_case_results.include?('FAILED')
          a.result = 'PASSED'
          a.define_singleton_method(:class) do
            'element-item passed '
          end
        else
          a.result = 'NO RESULT'
          a.define_singleton_method(:class) do
            'element-item no_result '
          end
      end
    end
  end

end