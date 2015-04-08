class TestCaseResult
  include DataMapper::Resource
  property :id, Serial
  property :result, String, :required => true
  property :message, Text, :required => true
  property :revision, String

  belongs_to :test_execution
  belongs_to :test_case
  belongs_to :environment
  belongs_to :test_suite

  def save
    begin
      super
    rescue DataMapper::SaveFailureError => e
      message = "Saving test case result failed with message: #{e.resource.errors.inspect}"
      p message
      $logger.error(message)
    end
  end
end