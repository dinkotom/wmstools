require_relative('setup_tests')

class TestViewPerformance < Test::Unit::TestCase
  include Rack::Test::Methods
  include HelpersMain

#  def app
#    Sinatra::Application
#  end
#
#  def test_getting_performance_test_suits
#    get '/performance/suites'
#    assert_equal(
#        [
#            {:name => '[F] PERFORMANCE TESTS'},
#            {:name => '[H] PERFORMANCE TESTS'},
#            {:name => '[P] KAMIL'},
#        ].to_json, last_response.body)
#  end
#
#  def test_calling_existent_test_suite_that_is_not_performance
#    get '/performance/suites/%5BF%5D%20SMOKE%20TESTS/1'
#    assert_equal('[F] SMOKE TESTS is not a valid performance test suite!', last_response.body)
#  end
#
#  def test_calling_non_existent_test_suite
#    get '/performance/suites/NON%20EXISTENT%20TEST%20SUITE/1'
#    assert_equal('NON EXISTENT TEST SUITE is not a valid performance test suite!', last_response.body)
#  end
end
