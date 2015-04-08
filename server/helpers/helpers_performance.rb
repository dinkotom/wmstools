module HelpersPerformance
  def collect_performance_measurement_point_ids(test_suite)
    test_executions = TestExecution.all(:test_suite_name => test_suite, :result => 'PASSED', :order => [:enqueued_at.desc])
    measurement_points = Array.new
    test_executions.each do |test_execution|
      measurement_points << PerformanceMeasurement.all(:test_execution => test_execution)
    end
    measurement_points.flatten.collect { |a| a.performance_measurement_point_id }.uniq.sort
  end

  def compose_performance_test_results_json(test_suite_name, page)
    if TestSuite.all(:performance => true).collect { |a| a.name }.include?(test_suite_name)
      point_ids = collect_performance_measurement_point_ids(test_suite_name)
      table_data = Array.new
      table_data_row = Hash.new
      page = page.to_i
      table_data_row[:this_page_number] = page
      number_of_executions = TestExecution.all(:test_suite_name => test_suite_name,
                                               :result => 'PASSED',
                                               :hidden => false).count
      number_of_pages = (number_of_executions.to_f / PERFORMANCE_TEST_RESULTS_PER_PAGE.to_f).ceil
      table_data_row[:number_of_pages] = number_of_pages
      table_data << table_data_row
      table_data_row = Hash.new
      table_data_row[:style] = 'header'
      table_data_row[:columns] = Hash.new
      table_data_row[:columns]['Test Execution'] = Hash.new
      table_data_row[:columns]['Test Execution'][:value] = 'Reference Value (Max Value)'
      table_data_row[:columns]['Test Execution'][:style] = 'header'
      point_ids.each do |point_id|
        point = PerformanceMeasurementPoint.get(point_id, test_suite_name)
        point ? point_label = point.name : point_label = point_id
        point ? reference_max_value = "#{point.reference_value} (#{point.max_value})" : reference_max_value = ''
        table_data_row[:columns][point_label] = Hash.new
        table_data_row[:columns][point_label][:value] = reference_max_value
        table_data_row[:columns][point_label][:style] = 'header'
      end
      table_data << table_data_row
      TestExecution.all(:test_suite_name => test_suite_name,
                        :result => 'PASSED',
                        :hidden => false,
                        :order => [:enqueued_at.desc],
                        :offset => PERFORMANCE_TEST_RESULTS_PER_PAGE * (page - 1),
                        :limit => PERFORMANCE_TEST_RESULTS_PER_PAGE
      ).each do |execution|
        table_data_row = Hash.new
        table_data_row[:style] = 'default'
        table_data_row[:columns] = Hash.new
        table_data_row[:columns]['Test Execution'] = Hash.new
        table_data_row[:columns]['Test Execution'][:value] = execution.enqueued_at.strftime('%Y-%m-%d - %H:%M')
        table_data_row[:columns]['Test Execution'][:style] = 'link'
        table_data_row[:columns]['Test Execution'][:link] = "/test_runner/#{execution.id}"
        point_ids.each do |point_id|
          point = PerformanceMeasurementPoint.get(point_id, test_suite_name)
          point ? point_label = point.name : point_label = point_id
          table_data_row[:columns][point_label] = Hash.new
          measurement = PerformanceMeasurement.get(execution.id, point_id, test_suite_name)
          if measurement
            measured_value = measurement.value.to_i
            if point
              max_value = point.max_value.to_i
              comparison = measured_value - point.reference_value.to_i
              table_data_row[:columns][point_label][:value] = "#{measured_value} (#{'+' if comparison > 0}#{comparison})"
              if measured_value > max_value then
                table_data_row[:columns][point_label][:style] = 'failed'
                table_data_row[:style] = 'failed'
              else
                table_data_row[:columns][point_label][:style] = 'default'
              end
            else
              table_data_row[:columns][point_label][:value] = measured_value.to_s
              table_data_row[:columns][point_label][:style] = 'default'
            end
          else
            table_data_row[:columns][point_label][:value] = ''
            table_data_row[:columns][point_label][:style] = 'default'
          end
        end
        table_data << table_data_row
      end
      table_data.to_json
    else
      "#{test_suite_name} is not a valid performance test suite!"
    end
  end

  def list_performance_test_suites
    json_data = Array.new
    TestSuite.all(:performance => true, :order => [:priority.asc]).collect do |suite|
      json_data_row = Hash.new
      json_data_row[:name] = suite.name
      json_data << json_data_row
    end
    json_data.to_json
  end
end