class DeliverySite
  include DataMapper::Resource

  property :id, String, :key => true
  property :expired, Boolean, :default => false
  property :created_at, Date, :default => DateTime.new(1945,5,8)

  belongs_to :delivery_site_type
  belongs_to :environment

  def self.first_or_create(attributes)
    attributes[:created_at] = DateTime.now
    begin
      super unless DeliverySite.get(attributes[:id])
    rescue DataMapper::SaveFailureError => e
      message = "Saving delivery site failed with message: #{e.resource.errors.inspect}"
      p message
      $logger.error(message)
    end
  end

  def expire
    self.update(:expired => true)
  end

  def self.get_one(type, environment)
    delivery_site = self.all(
        :delivery_site_type_id => type,
        :environment_name => environment,
        :expired => false,
        :order => [:created_at.asc]
    ).first

    if delivery_site
      delivery_site.expire
      status = 'OK'
      reason = ''
    else
      delivery_site.define_singleton_method(:id) do
        ''
      end
      status = 'FAILED'
      reason = "No delivery sites of type '#{type}' for '#{environment}' are in the stock. Please, contact administrator."
    end
    return delivery_site, status, reason
  end

  def self.check_storage
    DeliverySiteType.all.each do |ds_type|
      ds_type.environments.each do |environment|
        if DeliverySite.all(:delivery_site_type => ds_type, :environment => environment, :expired => false).count < ds_type.quota

          already_pending = TestExecution.all(
              :test_suite => ds_type.test_suite,
              :delivery_site_type => ds_type,
              :environment => environment,
              :status => 'Pending'
          ).count > 0

          already_running = TestExecution.all(
              :test_suite => ds_type.test_suite,
              :delivery_site_type => ds_type,
              :environment => environment,
              :status => 'Running'
          ).count > 0

          recently_failing = TestExecution.all(
              :test_suite => ds_type.test_suite,
              :delivery_site_type => ds_type,
              :environment => environment,
              :order => [:id.desc],
              :status => 'Finished',
              :limit => BUFFER_TEST_MAX_FAILED
          ).select { |te| te.result != 'PASSED' }.count == BUFFER_TEST_MAX_FAILED

          unless already_running || already_pending || recently_failing
            test_execution = TestExecution.new
            test_execution.test_suite_name = ds_type.test_suite.name
            test_execution.delivery_site_type = ds_type
            test_execution.environment = environment
            test_execution.for = 'BUFFERER'
            test_execution.enqueue
          end
        end
      end
    end
  end

  def self.get_stock
    output = Hash.new
    DeliverySiteType.each do |ds_type|
      environments_stock = Hash.new
      ds_type.environments.each do |environment|
        environments_stock[environment.name] = DeliverySite.all(:delivery_site_type => ds_type, :environment => environment, :expired => false).count
      end
      output[ds_type.name] = environments_stock
    end
    output
  end

end
