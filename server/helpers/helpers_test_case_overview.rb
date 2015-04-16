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
    TestCase.all.select { |tc| tc.environments.get(environment.name) }.each do |tc|
      test_case_results = TestCaseResult.all(
            :revision => revision,
            :test_case_id => tc.id,
            :environment_name => environment.name,
            :order => [:id.asc]
        ).collect {|tcr|tcr.result}
      case
        when test_case_results.include?('FAILED')
          tc.tco_result = 'FAILED'
          tc.tco_class = 'element-item failed '
        when test_case_results.size > 0 && !test_case_results.include?('FAILED')
          tc.tco_result = 'PASSED'
          tc.tco_class = 'element-item passed '
        else
          tc.tco_result = 'NO RESULT'
          tc.tco_class = 'element-item no_result '
      end
    end
  end
end