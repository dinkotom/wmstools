require_relative('../helpers/helpers_performance')
helpers HelpersPerformance

get '/performance' do
  erb :performance
end

get '/performance/suites' do
  list_performance_test_suites
end

get '/performance/suites/:test_suite/:page' do
  compose_performance_test_results_json(params[:test_suite], params[:page])
end

get '/performance/xls/:test_suite_name' do
  test_suite_name = params[:test_suite_name]
  point_ids = collect_performance_measurement_point_ids(test_suite_name)

  Dir.mkdir('tmp') unless File.exists?('tmp')
  path_to_tmp_file = "./tmp/#{DateTime.now.strftime('%Y_%m_%d_%H_%M_%S')}_tmp.xslx"

  Axlsx::Package.new do |p|
    p.workbook.add_worksheet(:name => "Performance Tests Results") do |sheet|

      sheet.add_row [test_suite_name]

      sheet.add_row ['Enqueued at'] + point_ids.collect {|a|PerformanceMeasurementPoint.get(a, test_suite_name).name or a}

      TestExecution.all(:test_suite_name => test_suite_name,
                        :result => 'PASSED',
                        :hidden => false,
                        :order => [:enqueued_at.desc],
      ).each do |execution|
        sheet.add_row [execution.enqueued_at.strftime('%Y-%m-%d - %H:%M')] + point_ids.collect {|point_id| PerformanceMeasurement.get(execution.id, point_id, test_suite_name).value if PerformanceMeasurement.get(execution.id, point_id, test_suite_name)}
      end

      p.serialize(path_to_tmp_file)
    end
    t = Thread.new do
      sleep 5
      File.delete(path_to_tmp_file)
    end

    send_file path_to_tmp_file, :filename => "performance_#{DateTime.now.strftime('%Y_%m_%d_%H_%M_%S')}.xlsx", :type => 'Application/octet-stream'

    t.join
  end
end
