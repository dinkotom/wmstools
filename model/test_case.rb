class TestCase
  attr_accessor :result

  include DataMapper::Resource
  property :id, String, :key => true
  property :name, Text, :default => 'Test Case name not specified.'
  has n, :environments, :through => Resource

  def save
    begin
      super
    rescue DataMapper::SaveFailureError => e
      message = "Saving test case failed with message: #{e.resource.errors.inspect}"
      p message
      $logger.error(message)
    end
  end

  def self.create(properties)
    begin
      super(properties)
    rescue DataMapper::SaveFailureError => e
      message = "Creating test case failed with message: #{e.resource.errors.inspect}"
      p message
      $logger.error(message)
    end
  end
end