require_relative('../helpers/helpers_test_case_overview')
helpers HelpersTestCaseOverview

get '/test_case_overview' do
  @environments = Environment.all.collect { |a| a.name }
  @revision = ''
  @tc_count = ''
  @tc_passed = ''
  @tc_failed = ''
  @tc_no_result = ''
  @tc_passed_percent = ''
  @tc_passed_percent_style = 'tco grey'
  @test_cases = []

  erb :test_case_overview
end

get '/test_case_overview/:environment' do
  halt 404, "Environment #{params[:environment]} does not exist." unless Environment.get(params[:environment])
  environment = Environment.get(params[:environment])
  newest_revision = get_newest_revision(environment)
  @test_cases = get_test_cases(environment, newest_revision)
  @environments = Environment.all.collect { |a| a.name }
  @environment = environment.name
  @revision = newest_revision
  @tc_count = @test_cases.count
  @tc_passed = @test_cases.select { |a| a.tco_result == 'PASSED' }.count
  @tc_failed = @test_cases.select { |a| a.tco_result == 'FAILED' }.count
  @tc_no_result = @test_cases.select { |a| a.tco_result == 'NO RESULT' }.count
  @tc_count > 0 ? @tc_passed_percent = ((@tc_passed.to_f / @tc_count.to_f) * 100).round(0) : @tc_passed_percent = 'N/A'
  if @tc_passed_percent.is_a?(Integer)
    case
      when @tc_passed_percent.to_i > 90
        @tc_passed_percent_style = 'tco green'
      when @tc_passed_percent.to_i > 80 && @tc_passed_percent.to_i < 90
        @tc_passed_percent_style = 'tco orange'
      when @tc_passed_percent.to_i < 80
        @tc_passed_percent_style = 'tco red'
    end
  else
    @tc_passed_percent_style = 'tco grey'
  end

  erb :test_case_overview
end

