require './initialize_server.rb'

# require 'rack/cache'
#
# use Rack::Cache,
#     :verbose     => true,
#     :metastore   => 'file:/var/cache/rack/meta',
#     :entitystore => 'file:/var/cache/rack/body'

run Sinatra::Application