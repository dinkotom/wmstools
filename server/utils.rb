class Utils

  def check_data_integrity
    message = String.new
    TestSuite.all(:piazza => true).each do |test|
      if test.respond_to?('default_number_of_tests') then
        message << "#{test.name}.default_number_of_tests is not Integer\n" if not test.default_number_of_tests.kind_of?(Integer)
      else
        message << "#{test.name} is supposed to be displayed in Piazza but default number of tests is not set.\n"
      end
    end
    message
  end

  def save_environments_definition
    Environment.auto_migrate!
    ENVIRONMENTS.each do |definition|
      Environment.create(:name => definition[:name], :wms_version_name => definition[:wms_version])
    end
  end

  def save_test_suites
    TestSuite.auto_migrate!
    TEST_SUITES.each do |test_suite|
      begin
        test_suite_resource = TestSuite.create(
            :name => test_suite[:name],
            :type => test_suite[:type],
            :piazza => test_suite[:piazza],
            :default_number_of_tests => test_suite[:default_number_of_tests],
            :priority => test_suite[:priority],
            :performance => test_suite[:performance],
            :load => test_suite[:load],
            :buffer => test_suite[:buffer],
            :project_file => test_suite[:project_file]
        )
        test_suite[:environments].each do |environment|
          test_suite_resource.environments << Environment.get(environment)
        end
        test_suite_resource.save
      rescue DataMapper::SaveFailureError => e
        p 'SAVE BASE DATA ERROR: ' + e.resource.errors.inspect
      end
    end
  end

  def save_test_packages
    TestPackage.auto_migrate!
    TEST_PACKAGES.each do |test_package|
      begin
        test_package_resource = TestPackage.create(:name => test_package[:name])
        test_package[:suites].each do |test_suite|
          test_package_resource.test_suites << TestSuite.get(test_suite)
        end
        test_package_resource.save
      rescue DataMapper::SaveFailureError => e
        p 'SAVE BASE DATA ERROR: ' + e.resource.errors.inspect
      end
    end
  end

  def save_performance_tests_measurement_points
    if defined? PERFORMANCE_TESTS
      PerformanceMeasurementPoint.auto_migrate!
      PERFORMANCE_TESTS.each do |suite|
        suite[:performance_measurement_points].each do |point|
          PerformanceMeasurementPoint.first_or_create(:id => point[:id], :name => point[:name], :reference_value => point[:reference_value], :max_value => point[:max_value], :test_suite_name => suite[:test_suite_name])
        end
      end
    end
  end

  def save_test_executions
    if defined? TEST_EXECUTIONS
      TEST_EXECUTIONS.each do |config_line|
        test_execution = TestExecution.new
        test_execution.environment_name = config_line[:environment_name]
        test_execution.test_suite_name = config_line[:test_suite_name]
        test_execution.enqueued_at = config_line[:enqueued_at]
        test_execution.result = config_line[:result]
        begin
          test_execution.save
        rescue DataMapper::SaveFailureError => e
          p 'SAVE TEST DATA ERROR: ' + e.resource.errors.inspect
        end
      end
    end
  end

  def save_performance_measurements
    if defined? PERFORMANCE_MEASUREMENTS
      PERFORMANCE_MEASUREMENTS.each do |config_line|
        begin
          PerformanceMeasurement.create(config_line)
        rescue DataMapper::SaveFailureError => e
          p 'SAVE TEST DATA ERROR: ' + e.resource.errors.inspect
        end
      end
    end
  end

  def save_piazza_screens
    if defined? PIAZZA_SCREENS
      PiazzaScreen.auto_migrate!
      EnvironmentPiazzaScreen.auto_migrate!
      begin
        PIAZZA_SCREENS.each do |screen|
          screen_resource = PiazzaScreen.create(:screen_number => screen[:screen_number])
          screen[:environments].each do |environment|
            screen_resource.environments << Environment.get(environment)
          end
          screen_resource.save
        end
      rescue DataMapper::SaveFailureError => e
        p 'SAVE TEST DATA ERROR: ' + e.resource.errors.inspect
      end
    end
  end

  def save_delivery_site_types
    if defined? DELIVERY_SITE_TYPES
      DeliverySiteType.auto_migrate!
      DeliverySiteTypeEnvironment.auto_migrate!
      begin
        DELIVERY_SITE_TYPES.each do |ds_type|
          ds_type_resource = DeliverySiteType.create(
              :id => ds_type[:id],
              :name => ds_type[:name],
              :test_suite_name => ds_type[:test_suite_name],
              :quota => ds_type[:quota]
          )
          ds_type[:environments].each do |environment|
            ds_type_resource.environments << Environment.get(environment)
          end
          ds_type_resource.save
        end
      rescue DataMapper::SaveFailureError => e
        p 'SAVE TEST DATA ERROR: ' + e.resource.errors.inspect
      end
    end
  end

  def upgrade_delivery_sites_environments
    DeliverySite.all(:environment_name => '').each { |ds| ds.update(:environment_name => 'FAT') }
  end

  def to_link(prefix, name)
    prefix.match(/\/$/) or prefix << '/'
    "<a href=\"#{prefix + name}\" target=\"_blank\">#{name}</a>"
  end

  def import_delivery_sites
    before_count = DeliverySite.all.count
    s = SimpleSpreadsheet::Workbook.read('/home/dinkotom/Dropbox/projects/wms-tools_new-checkout/server/public/import/skagerak_ds.xlsx')

    p "Importing Disconnected Delivery Sites"
    s.selected_sheet = s.sheets.first
    s.first_row.upto(s.last_row) do |line|
      unless line == 1
        case
          when s.cell(line, 3)
            ds_type = '[S] SKA REG DISC + TRA'
          else
            ds_type = '[S] SKA REG DISC'
        end
        DeliverySite.first_or_create(
            :id => s.cell(line, 1),
            :expired => false,
            :delivery_site_type_id => ds_type,
            :environment_name => 'DEV2SKA'
        )
      end
    end

    p "Importing Active Delivery Sites"
    s.selected_sheet = s.sheets[1]
    s.first_row.upto(s.last_row) do |line|
      unless line == 1
        case
          when s.cell(line, 2) && s.cell(line, 2) == 'J'
            if s.cell(line, 3)
              ds_type = '[S] SKA HOUR + TRA'
            else
              ds_type = '[S] SKA HOUR'
            end
          else
            if s.cell(line, 3)
              ds_type = '[S] SKA REG + TRA'
            else
              ds_type = '[S] SKA REG'
            end
        end
        DeliverySite.first_or_create(
            :id => s.cell(line, 1),
            :expired => false,
            :delivery_site_type_id => ds_type,
            :environment_name => 'DEV2SKA'
        )
      end
    end

    after_count = DeliverySite.all.count
    counter = after_count - before_count
    p "Finished Importing Disconnected Delivery Sites. #{counter} delivery sites imported."
  end
end
