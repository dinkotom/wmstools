class PerformanceMeasurement
  include DataMapper::Resource
  property :value, Integer

  belongs_to :test_execution, :key => true
  belongs_to :performance_measurement_point, :key => true

  def create
    begin
      super
    rescue DataMapper::SaveFailureError => e
      message = "Creating performance measurement failed with message: #{e.resource.errors.inspect}"
      p message
      $logger.error(message)
    end
  end
end