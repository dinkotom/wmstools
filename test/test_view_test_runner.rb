require_relative('setup_tests')

class RunnerBasicTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def setup
    @data = {'for' => 'radovan.fekec@tieto.com',
             'test_suite_name' => 'FULL REGRESSION TEST',
             'environment' => 'FAT'
    }

    @te = TestExecution.new
    @te.test_suite_name = "SMOKE TEST"
    @te.environment_name ="FAT"
    @te.for = "radovan.fekec@tieto.com"
    @te.status = 'Pending'
    @te.enqueued_at = DateTime.now
    @te.report = 'report'
    @te.save

    @test_comment = "ABCD"
    @test_jira = "Delete this comment"

  end

  def test_enqueuing_package
    TestExecution.destroy!
    post '/test_runner/enqueue', @data
    enqueued_test_suits = Array.new
    TestExecution.all(:order => [:enqueued_at.asc]).each do |test_execution|
      enqueued_test_suits << test_execution.test_suite_name
    end
    assert_equal ['[F] SMOKE TESTS',
                  '[F] WEB SERVICE TESTS',
                  '[F] REGRESSION TESTS 1',
                  '[F] REGRESSION TESTS 2',
                  '[F] REGRESSION TESTS 3',
                  '[F] REGRESSION TESTS 4',
                  '[F] REGRESSION TESTS 5',
                 ], enqueued_test_suits
  end

  def test_saving_comment
    post "/test_runner/#{@te.id.to_s}/save_comment", {'comment' => @test_comment}

    assert_equal @test_comment, TestExecution.get(@te.id).comment
    assert_equal "1", last_response.body
  end

  def test_getting_comment
    @te.comment = @test_comment
    @te.save

    get "/test_runner/#{@te.id.to_s}/get_comment"

    assert_equal @test_comment, last_response.body
  end

  def test_hiding_test_execution
    post "/test_runner/#{@te.id.to_s}/hide_ajax"
    assert_equal "1", last_response.body
  end

  def test_removing_test_execution
    post "/test_runner/#{@te.id.to_s}/remove_ajax"
    assert_equal "1", last_response.body
  end

  def test_table_data_returns_data

    environment = "FAT4"
    test_suite_name = "SMOKE TESTS"

    expected_items = TestExecution.all(:hidden => false, :test_suite_name => test_suite_name, :environment_name => environment).count

    post '/test_runner/table_data', {"page" => 1, "items" => expected_items, "environment" => environment, "test_suite" => test_suite_name}

    actual_items = JSON.parse(last_response.body).find{|x| x["items_count"]}["items_count"].to_i()

    assert_equal expected_items, actual_items
  end

  def test_getting_packages
    post '/test_runner/test_suites', {'environment' => 'FAT', 'scope' => 'package'}
    assert_equal([{'value' => 'FULL REGRESSION TEST'}].to_json, last_response.body)
  end

  def test_getting_single_tests
    post '/test_runner/test_suites', {'environment' => 'FAT4', 'scope' => 'single'}
    assert_equal([
                     {'value' => '[F] SMOKE TESTS'},
                     {'value' => '[F] WEB SERVICE TESTS'},
                     {'value' => '[F] REGRESSION TESTS 1'},
                     {'value' => '[F] REGRESSION TESTS 2'},
                     {'value' => '[F] REGRESSION TESTS 3'},
                     {'value' => '[F] LOAD TESTS'},
                     {'value' => '[F] MAINTENANCE TESTS'},
                     {'value' => '[F] PERFORMANCE TESTS'},
                     {'value' => '[F] BUFFER TESTS'},
                 ].to_json, last_response.body)
  end
end
