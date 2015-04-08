require_relative('setup_tests')

class TestViewPerformance < Test::Unit::TestCase
  include Rack::Test::Methods
  include HelpersMain

  def app
    Sinatra::Application
  end

  def setup
    DeliverySite.destroy!
    @ds = DeliverySite.create(
                    :id => '123456789',
                    :delivery_site_type_id => 'type4manual',
                    :expired => false,
                    :environment_name => 'FAT'
    )
  end

  def test_getting_ds
    post '/get_ds_ws', {'type' => 'type4manual', 'environment' => 'FAT'}
    assert_equal({
                     :status => 'OK',
                     :reason => '',
                     :ds_id => '123456789',
                     :ds_type => 'type4manual',
                     :environment => 'FAT'

    }.to_json, last_response.body)
  end

  def test_out_of_stock
    @ds.expire
    post '/get_ds_ws', {'type' => 'type4manual', 'environment' => 'FAT'}
    assert_equal({
                     :status => 'FAILED',
                     :reason => "No delivery sites of type 'type4manual' for 'FAT' are in the stock. Please, contact administrator.",
                     :ds_id => '',
                     :ds_type => 'type4manual',
                     :environment => 'FAT',
                 }.to_json, last_response.body)
  end

  def test_invalid_ds_type
    post '/get_ds_ws', {'type' => 'non_existent', 'environment' => 'FAT'}
    assert_equal({
                     :status => 'FAILED',
                     :reason => "No delivery sites of type 'non_existent' for 'FAT' are in the stock. Please, contact administrator.",
                     :ds_id => '',
                     :ds_type => 'non_existent',
                     :environment => 'FAT',
                 }.to_json, last_response.body)
  end

  def test_invalid_environment
    post '/get_ds_ws', {'type' => 'type4manual', 'environment' => 'non_existent'}
    assert_equal({
                     :status => 'FAILED',
                     :reason => "No delivery sites of type 'type4manual' for 'non_existent' are in the stock. Please, contact administrator.",
                     :ds_id => '',
                     :ds_type => 'type4manual',
                     :environment => 'non_existent',
                 }.to_json, last_response.body)
  end

end
