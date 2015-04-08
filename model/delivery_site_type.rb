class DeliverySiteType
  include DataMapper::Resource

  property :id, String, :key => true
  property :name, Text, :default => 'Delivery Site type name not specified.'
  property :quota, Integer, :default => 0

  has n, :delivery_sites
  has n, :test_executions
  has n, :environments, :through => Resource

  belongs_to :test_suite, :required => false

  def self.get_environments
    output = Array.new
    self.all.each do |ds_type|
      ds_type.environments.each do |environment|
        output << environment.name
      end
    end
    output.uniq
  end

end