require_relative('setup_tests')

class TestViewTestCaseOverview < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_non_existent_environment_input
    get '/test_case_overview/non_existent_environment'
    assert_equal(404, last_response.status)
  end

end