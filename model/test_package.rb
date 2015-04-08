class TestPackage
  include DataMapper::Resource
  property :name, String, :key => true

  has n, :test_suites, :through => Resource
end