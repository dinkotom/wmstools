class TestSuite
  include DataMapper::Resource
  property :name, String, :key => true
  property :type, String
  property :piazza, Boolean
  property :default_number_of_tests, Integer
  property :priority, Integer
  property :performance, Boolean
  property :load, Boolean
  property :buffer, Boolean
  property :soapui_project_file, String

  has n, :test_executions
  has n, :environments, :through => Resource
  has n, :test_packages, :through => Resource
  has n, :performance_measurement_points
  has n, :test_case_results
end