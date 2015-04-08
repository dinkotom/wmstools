class Environment
  include DataMapper::Resource
  property :name, String, :key => true

  belongs_to :wms_version
  has n, :test_suites, :through => Resource
  has n, :piazza_screens, :through => Resource
  has n, :test_cases, :through => Resource
  has n, :test_case_results
  has n, :delivery_site_types, :through => Resource
end