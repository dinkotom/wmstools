class PiazzaScreen
  include DataMapper::Resource
  property :screen_number, Integer, :key => true
  has n, :environments, :through => Resource
end