class PerformanceMeasurementPoint
  include DataMapper::Resource
  property :id, String, :key => true
  property :name, String
  property :reference_value, Integer
  property :max_value, Integer
  property :test_suite_name, String, :key => true

  belongs_to :test_suite

  has n, :performance_measurements
end