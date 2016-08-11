require_relative('setup_tests')

class DeliverySiteTest < Test::Unit::TestCase
#  def setup
#    TestExecution.destroy!
#    DeliverySite.destroy!
#  end
#
#  def test_getting_oldest_delivery_site
#    5.times do |count|
#      DeliverySite.first_or_create(
#          :id => 4 - count,
#          :expired => false,
#          :delivery_site_type => DeliverySiteType.get('type1'),
#          :environment => Environment.get('FAT')
#      )
#    end
#
#    delivery_site, status, reason = DeliverySite.get_one('type1', 'FAT')
#
#    assert_equal('4', delivery_site.id)
#  end
#
#  def test_enquing_when_quota_not_reached
#    5.times do |count|
#      DeliverySite.create(
#          :id => count,
#          :expired => false,
#          :delivery_site_type => DeliverySiteType.get('type1'),
#          :environment => Environment.get('FAT')
#      )
#    end
#
#    6.times do |count|
#      DeliverySite.create(
#          :id => count + 5,
#          :expired => false,
#          :delivery_site_type => DeliverySiteType.get('type1'),
#          :environment => Environment.get('FAT4')
#      )
#    end
#
#    DeliverySite.check_storage
#
#    assert_equal(
#        1,
#        TestExecution.all(
#            :delivery_site_type => DeliverySiteType.get('type1'),
#            :environment => Environment.get('FAT'),
#            :test_suite => TestSuite.get('[F] BUFFER TESTS')
#
#        ).count
#    )
#  end
#
#  def test_not_enquing_when_quota_reached
#    2.times do |count|
#      DeliverySite.create(
#          :id => count,
#          :expired => false,
#          :delivery_site_type => DeliverySiteType.get('type2'),
#          :environment => Environment.get('FAT')
#      )
#    end
#
#    DeliverySite.check_storage
#
#    assert_equal(
#        0,
#        TestExecution.all(
#            :delivery_site_type => DeliverySiteType.get('type2'),
#            :environment => Environment.get('FAT'),
#            :test_suite => TestSuite.get('[F] BUFFER TESTS')
#
#        ).count
#    )
#  end
#
#  def test_enqueuing_buffer_tests
#    DeliverySite.check_storage
#    assert_equal(6, TestExecution.all.count)
#  end
#
#  def test_stopping_buffering_when_failing
#    BUFFER_TEST_MAX_FAILED.times do
#      TestExecution.create(
#          :test_suite_name => '[F] BUFFER TESTS',
#          :environment_name => 'FAT',
#          :delivery_site_type_id => 'type1',
#          :status => 'Finished',
#          :result => 'FAILED'
#      )
#    end
#
#    DeliverySite.check_storage
#    assert_equal(5, TestExecution.all(
#                      :test_suite_name => '[F] BUFFER TESTS',
#                      :environment_name => 'FAT',
#                      :delivery_site_type_id => 'type1'
#                  ).count
#    )
#  end
#
#  def test_stopping_buffering_when_no_result
#    BUFFER_TEST_MAX_FAILED.times do
#      TestExecution.create(
#          :test_suite_name => '[F] BUFFER TESTS',
#          :environment_name => 'FAT',
#          :delivery_site_type_id => 'type1',
#          :status => 'Finished',
#          :result => 'No Result'
#      )
#    end
#
#    DeliverySite.check_storage
#    assert_equal(5, TestExecution.all(
#                      :test_suite_name => '[F] BUFFER TESTS',
#                      :environment_name => 'FAT',
#                      :delivery_site_type_id => 'type1'
#                  ).count
#    )
#  end
#
#  def test_not_enqueuing_manually_buffered_ds_types
#    manually_buffered_ds_type = DeliverySiteType.get('type4manual').id
#    DeliverySite.check_storage
#    assert_equal([], TestExecution.all.select { |te| te.delivery_site_type_id == manually_buffered_ds_type })
#  end
#
#  def teardown
#
#  end
end