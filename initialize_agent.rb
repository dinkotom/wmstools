require 'bundler'
Bundler.require(:default)

$logger = Logger.new('log')
$logger.level = Logger::DEBUG

require_relative('agent/config/conf_common')

$0 =~ /test/ ? require_relative('agent/config/conf_test') : require_relative("agent/config/conf_#{ENVIRONMENT}.rb")

Dir[".*/model/*.rb"].each {|file| require(file)}
Dir[".*/agent/controllers/*.rb"].each { |file| require(file) }

DataMapper::Model.raise_on_save_failure = true

DataMapper::setup(:default, DATA_SOURCE)

DataMapper.finalize.auto_upgrade!

print "WMSTools Agent '#{THIS_AGENT_ID}' started against '#{DATA_SOURCE}'.\n"
print "Waiting for dequeuing.\n"

require_relative('agent/operating_system')
require_relative('agent/agent_scheduler')




