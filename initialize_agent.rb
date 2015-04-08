require 'bundler'
Bundler.require(:default)

$logger = Logger.new('log')
$logger.level = Logger::DEBUG

require_relative('agent/config/conf_common')

ENVIRONMENT == 'production' ? require_relative('agent/config/conf_production') : require_relative('agent/config/conf_development')

Dir[".*/model/*.rb"].each {|file| require(file)}

DataMapper::Model.raise_on_save_failure = true

DataMapper::setup(:default, DATA_SOURCE)

DataMapper.finalize.auto_upgrade!

print "WMSTools Agent '#{THIS_AGENT_ID}' started against '#{DATA_SOURCE}'.\n"
print "Waiting for dequeuing.\n"

require_relative('agent/operating_system')
require_relative('agent/agent_scheduler')




