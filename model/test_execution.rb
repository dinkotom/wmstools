class TestExecution
  include DataMapper::Resource
  property :id, Serial
  property :revision, String
  property :report, Text
  property :comment, Text
  property :jira_issue, String
  property :result, String
  property :for, String
  property :status, String
  property :enqueued_at, DateTime
  property :started_at, DateTime
  property :finished_at, DateTime
  property :hidden, Boolean, :default => false
  property :agent, String
  property :pid, String
  property :exit_code, Integer
  property :stderr, Text
  property :output_zip_base64, Text, :length => 2000000

  belongs_to :environment
  belongs_to :test_suite
  belongs_to :delivery_site_type, :required => false

  has n, :performance_measurements
  has n, :test_case_results

  def self.dequeue(os = nil)
    # do nothing if number of running test executions on this agent already reached the quota
    return nil if TestExecution.all(:status => 'Running', :agent => THIS_AGENT_ID).count >= QUOTA
    # comment end

    # do nothing if there is a test in status 'Preparing' on this agent
    return nil if TestExecution.all(:status => 'Preparing', :agent => THIS_AGENT_ID).count > 0
    # comment end

    begin
      # this does not allow to simultaneously run more than one performance test execution of the same suite on the same environment
      test_executions = TestExecution.all(:status => 'Pending', :order => [:enqueued_at.asc]).collect do |a|
        a if TestExecution.all(:environment_name => a.environment_name, :test_suite_name => a.test_suite_name, :status => 'Running').count == 0 || !TestSuite.get(a.test_suite_name).performance
      end.compact
      # comment end

      if test_executions.count > 0

        test_execution = test_executions.first

        os ? test_execution.run(os) : test_execution.run
      end

    rescue => e
      message = "Dequeuing test execution FAILED with message: #{e.message}"
      $logger.error message
      p message
    end
  end

  property :id, Serial
  property :revision, String
  property :report, Text
  property :comment, Text
  property :jira_issue, String
  property :result, String
  property :for, String
  property :status, String
  property :enqueued_at, DateTime
  property :started_at, DateTime
  property :finished_at, DateTime
  property :hidden, Boolean, :default => false
  property :agent, String
  property :pid, String
  property :exit_code, Integer
  property :stderr, Text
  property :output_zip_base64, Text, :length => 2000000

  def self.rollback_running_executions
    (TestExecution.all(:status => 'Running') || TestExecution.all(:status => 'Preparing')).each do |te|
      te.status = 'Pending'
      te.revision = nil
      te.report = nil
      te.comment = nil
      te.jira_issue = nil
      te.result = nil
      te.started_at = nil
      te.finished_at = nil
      te.hidden = false
      te.agent = nil
      te.pid = nil
      te.exit_code = nil
      te.stderr = nil
      te.output_zip_base64 = nil
      te.save
      TestCaseResult.all(:test_execution => te).each {|tcr|tcr.destroy}
      PerformanceMeasurement.all(:test_execution => te).each {|pm|pm.destroy}
    end
  end

  def save
    begin
      super
    rescue DataMapper::SaveFailureError => e
      message = "Saving test execution #{self.id} failed with message: #{e.resource.errors.inspect}"
      p message
      $logger.error(message)
    end
  end

  def enqueue
    self.status = 'Pending'
    self.enqueued_at = DateTime.now
    begin
      self.save
      return true
    rescue DataMapper::SaveFailureError => e
      $logger.error(e.resource.errors.inspect)
      return false
    end
  end

  def run(os = OperatingSystem.new)
    os.folder = self.id.to_s
    os.project_file = self.test_suite.soapui_project_file
    os.suite = self.test_suite.name
    os.test_case = self.delivery_site_type.id if self.delivery_site_type
    os.branch = self.environment.wms_version.svn_branch

    self.status = 'Preparing'
    self.agent = THIS_AGENT_ID
    self.started_at = DateTime.now
    self.save

    self.status = os.run_soapui(self)
    self.result = evaluate_result unless TestExecution.get(self.id).result == 'KILLED'
    self.finished_at = DateTime.now
    self.exit_code = os.exit_status
    self.stderr = os.stderr[0..65000]
    self.stderr << 'Stderr has been cut to 65000 characters' if os.stderr.length > 65000
    self.save

    send_email if self.for.match(/.+@.+\..+/)
  end

  def trend
    previous_execution = TestExecution.all(:test_suite_name => self.test_suite_name, :environment_name => self.environment_name, :started_at.lt => self.started_at, :order => [:started_at.desc]).first
    case self.result
      when 'PASSED'
        current = 'Success'
      when 'FAILED'
        current = "#{self.failed_tests_count} failed"
      else
        current = 'unknown'
    end

    if previous_execution
      case previous_execution.result
        when 'PASSED'
          previous = 'Success'
        when 'FAILED'
          previous = "#{previous_execution.failed_tests_count} failed"
        else
          previous = 'unknown'
      end
    else
      previous = 'unknown'
    end

    self.status != 'Pending' ? "#{current} (was: #{previous})" : ''
  end

  def process_test_case_results_from_report(report)
    process_test_case_results(report) if report
  end

  private

  def send_email
    email = Email.new
    email.to = self.for
    email.subject = "SoapUI Test Results - #{self.started_at} - #{self.test_suite_name}: #{self.result} "
    email.html_body = self.report.gsub(/\n/, "<BR>\n")
    email.send
  end

  def evaluate_result
    failed_tests_count = TestCaseResult.all(:test_execution_id => self.id, :result => 'FAILED').count
    passed_tests_count = TestCaseResult.all(:test_execution_id => self.id, :result => 'PASSED').count
    case
      when failed_tests_count + passed_tests_count == 0
        'No result'
      when failed_tests_count > 0
        'FAILED'
      else
        'PASSED'
    end
  end

  def compose_report(passed_tests, failed_tests, exit_code, stderr)
    report = String.new
    report << "Test: #{self.test_suite_name}\n"
    report << "WMSVersion: #{Environment.get(self.environment_name).wms_version_name}\n"
    report << "Environment: #{self.environment_name}\n\n"
    report << "\n"
    report << "FAILED TESTS: #{failed_tests.size}\n"
    failed_tests.each do |test|
      report << test.message
    end
    report << "PASSED TESTS: #{passed_tests.size}\n"
    passed_tests.each do |test|
      report << test.message
    end
    report << "\n"
    report << "Exit code: #{exit_code}\n"
    report << "Stderr: #{stderr}\n" if exit_code != 0
    report = report[0..65000] << "Report has been cut to 65000 characters" if report.length > 65000
    report
  end

  def store_performance_measurements(run_test_stdout)
    if TestSuite.get(self.test_suite_name).performance && self.result == 'PASSED'
      hash = Hash.new
      run_test_stdout.scan(/\[(PERF\d*.?)\]\[(\d*)\]/).each do |measurement|
        hash[measurement[0]] = measurement[1].to_i
      end
      hash.each do |id, value|
        if PerformanceMeasurementPoint.get(id, self.test_suite_name)
          begin
            PerformanceMeasurement.create(:test_execution_id => self.id, :performance_measurement_point_id => id, :performance_measurement_point_test_suite_name => self.test_suite_name, :value => value)
          rescue DataMapper::SaveFailureError => e
            $logger.error(e.resource.errors.inspect)
          end
        end
      end
    end
  end
end
