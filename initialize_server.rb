VERSION='2.0.9'

require 'bundler/setup'
Bundler.require(:default)
Bundler.require(:server)

$logger = Logger.new('log')
$logger.level = Logger::DEBUG

set :server, :puma
set :environment, :test if $0 =~ /test/
set :public_folder, './server/public'
set :views, './server/views'

require_relative('server/config/conf_common')

set :environment, :production if ENVIRONMENT == 'production'

case
  when settings.test?
    require_relative('server/config/conf_test')
  when settings.development?
    require_relative('server/config/conf_development')
  when settings.production?
    require_relative('server/config/conf_production')
end

set :port, PORT

require_relative('server/model')
require_relative('server/utils')
require_relative('server/email')
require_relative('server/integration')
require_relative('server/helpers/helpers_main')
require_relative('server/configuration')

Configuration.validate

utils = Utils.new
WmsVersion.new.save_configuration
utils.save_environments_definition
utils.save_test_suites
utils.save_test_packages
utils.save_performance_tests_measurement_points
utils.save_test_executions
utils.save_performance_measurements
utils.save_piazza_screens
utils.save_delivery_site_types
utils.upgrade_delivery_sites_environments
# utils.import_delivery_sites
data_integrity_message = utils.check_data_integrity
data_integrity_message.size > 0 ? puts("!!!\n!!!Data integrity check failed with following message #{data_integrity_message}!!!") : puts('Data integrity check passed.')

Dir[".*/server/controllers/*.rb"].each { |file| require(file) }
require_relative('server/scheduler') unless settings.test?

p "WMSTools Server started against '#{DATA_SOURCE}'"


