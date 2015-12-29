require 'pty' if RUBY_PLATFORM =~ /linux/ || RUBY_PLATFORM =~ /darwin/ || RUBY_PLATFORM =~ /java/
require 'zip'
require 'base64'

class OperatingSystem

  attr_accessor :folder, :branch, :project_file, :suite, :environment, :test_case
  attr_reader :exit_status, :stderr

  UNIVERSAL_TESTS_MATCHING_REGEXP = /(\[TC\d{3}.*?\]) (.+) (PASSED|FAILED) .+/
  BUFFER_TESTS_MATCHING_REGEXP = /\[TC\d{3}.*?\] .+ (PASSED|FAILED) for DS (\d+)/
  PERFORMANCE_TEST_MATCHING_REGEXP = /\[(PERF\d*.?)\]\[(\d*)\]/
  START_STRING = '[SoapUITestCaseRunner] Running SoapUI tests in project'
  STOP_STRING = '[SoapUITestCaseRunner] Finished running SoapUI tests'
  REVISION_STRING = 'WMS build #\d{5}'

  def project_file=(file)
    @project_file = file
    @project_file_extension = @project_file.split('.').last
  end

  def compose_command
    command = "#{JAVA_HOME}"

    if @project_file_extension == 'xml'
      command << ' -Xms1024m -Xmx1024m -XX:MaxPermSize=128m -Dsoapui.properties=soapui.properties -Dgroovy.source.encoding=iso-8859-1'
      command << " -Dsoapui.home=#{SOAPUI_HOME}/bin"
      command << " -Dsoapui.ext.libraries=#{SVN_HOME}/#{branch}/requiredJARs"
      command << " -Dsoapui.ext.listeners=#{SOAPUI_HOME}/bin/listeners -Dsoapui.ext.actions=#{SOAPUI_HOME}/bin/actions"
      command << " -cp #{SOAPUI_HOME}/bin/soapui-5.2.0.jar:#{SOAPUI_HOME}/lib/*"
      command << " com.eviware.soapui.tools.SoapUITestCaseRunner -t #{SOAPUI_HOME}/soapui-settings.xml"
      command << " -s '#{@suite}'"
      command << " -c '#{@test_case}'" if test_case
      command << " -r #{SVN_HOME}/#{branch}/#{@project_file}"
      command << " -f '#{@folder}'"
      command << " -P screenshotPath='#{@folder}'"
    elsif @project_file_extension == 'jar'
      command << " -cp #{JAR_HOME}/#{branch}/target/#{@project_file}:#{JAR_HOME}/#{branch}/target/lib/*"
      command << ' com.tieto.test.ui.demo.Run'
      command << " #{@environment}"
      command << " '#{@suite}'"
    elsif @project_file_extension == 'txt'
      command = "#{FAKE_OUTPUT_HOME}/fake_output.sh #{FAKE_OUTPUT_HOME}/#{@project_file}"
    else
      raise 'Invalid project file. Must be either xml or jar.'
    end

    command << " 2> ./#{@folder}/stderr.txt|tee ./#{@folder}/stdout.txt"
  end

  def run(test_execution)
    begin
      raise ArgumentError, 'ERROR: folder, project_file, suite and branch must be set' unless @folder && @project_file && @suite && @branch

      Dir.mkdir(@folder) unless File.exists?(@folder)

      print "Updating svn branch '#{@branch}'\n"

      update_svn(@branch)

      message = "Starting running test execution id '#{@folder}' on branch '#{@branch}', suite '#{@suite}', project file '#{@project_file}' \n"
      print message
      $logger.info(message)

      begin
        $logger.info("Opening PTY using following command: #{compose_command}")
        PTY.spawn(compose_command) do |r, w, pid|
          save_pid(pid, test_execution)
          $logger.info("PTY opened with following PID: #{pid}")
          begin
            r.each do |line|

              scan_for_starting_running(line, test_execution) if test_execution.status == 'Preparing'

              if test_execution.status == 'Running'
                scan_for_test_cases(line, test_execution)
                scan_for_svn_revision(line, test_execution) unless test_execution.revision
                scan_for_delivery_sites(line, test_execution) if test_execution.test_suite.buffer
                scan_for_performance_measurements(line, test_execution) if test_execution.test_suite.performance
                scan_for_finished_running(line, test_execution)
              end

            end
          rescue Errno::EIO
          end
          Process.wait(pid)
          @exit_status = $?.exitstatus.to_i

          message = "Finished running test execution id '#{@folder}' on branch '#{@branch}', suite '#{@suite}', project file '#{@project_file}' \n"
          print message
          $logger.info(message)

          stderr_file = "./#{@folder}/stderr.txt"
          @stderr = File.read(stderr_file) if File.exist?(stderr_file)
          zipped_file = zip_output_files(@folder)
          save_zip_file(zipped_file, test_execution)
          delete_folder(@folder)
        end
      rescue PTY::ChildExited => e
        puts "The child process exited!"
      end

      @exit_status == 0 ? status = 'Finished' : status = 'Failed'

    rescue ArgumentError => e
      puts e.message
      puts e.backtrace.inspect
      status = 'Failed'
    end

    status
  end

  def self.kill_executions
    TestExecution.all(:status => 'Pending kill').each do |te|
      print "Attempting to kill test execution id '#{te.id}' using pid '#{te.pid}'.\n"
      system "kill -9 #{te.pid}"
      te.status = 'Killed'
      if $?.exitstatus == 0
        te.result = 'KILLED'
      else
        message = "Failed to kill test execution id '#{te.id}'.\n"
        $logger.error message
        print message
        te.status = 'Kill failed'
        te.result = 'KILL FAILED'
      end
      te.save
    end
  end

  private

  def update_svn(branch)
    case @project_file_extension
      when 'xml'
        dir = SVN_HOME
      when 'jar'
        dir = JAR_HOME
      else
        dir = SVN_HOME
    end

    command = "svn update #{dir}/#{branch}"
    system command
    $logger.error "Failed to update svn on branch '#{branch}'." unless $? == 0
  end

  def scan_for_starting_running(line, test_execution)
    if line.include?(START_STRING)
      test_execution.status = 'Running'
      test_execution.save
    end
  end

  def scan_for_test_cases(line, test_execution)
    line.scan(UNIVERSAL_TESTS_MATCHING_REGEXP) do |tc|
      matched_tc_id = tc[0]
      matched_tc_name = tc[1]
      matched_tc_result = tc[2]
      begin
        test_case = TestCase.first_or_create(:id => matched_tc_id)
        test_case.environments << Environment.get(test_execution.environment.name)
        test_case.save
        test_case.update(:name => matched_tc_name)
        TestCaseResult.create(
            {
                :revision => test_execution.revision,
                :test_case_id => matched_tc_id,
                :environment_name => test_execution.environment.name,
                :test_suite_name => test_execution.test_suite.name,
                :test_execution_id => test_execution.id,
                :result => matched_tc_result,
                :message => line.lstrip
            }
        )
      rescue DataMapper::SaveFailureError => e
        $logger.error(e.resource.errors.inspect)
      end
    end
  end


  def scan_for_svn_revision(line, test_execution)
    if line.match(REVISION_STRING)
      test_execution.revision = line.match(REVISION_STRING)[0][-5..-1]
      test_execution.save
    end
  end

  def scan_for_delivery_sites(line, test_execution)
    line.scan(BUFFER_TESTS_MATCHING_REGEXP) do |tc|
      result = tc[0]
      ds_id = tc[1]
      DeliverySite.first_or_create(:id => ds_id,
                                   :delivery_site_type_id => test_execution.delivery_site_type_id,
                                   :environment => test_execution.environment) if result == 'PASSED'
    end
  end


  def scan_for_performance_measurements(line, test_execution)
    match = line.match(PERFORMANCE_TEST_MATCHING_REGEXP)
    if match
      id = match[1]
      value = match[2]
      if PerformanceMeasurementPoint.get(id, test_execution.test_suite_name)
        PerformanceMeasurement.create(:test_execution_id => test_execution.id,
                                      :performance_measurement_point_id => id,
                                      :performance_measurement_point_test_suite_name => test_execution.test_suite_name,
                                      :value => value
        )
      else
        $logger.warn("Performance measurement point '#{id}' is not defined for test suite '#{test_execution.test_suite_name}'")
      end
    end
  end


  def scan_for_finished_running(line, test_execution)
    if line.include?(STOP_STRING)
      test_execution.status = 'Finalizing'
      test_execution.save
    end
  end

  def save_pid(pid, test_execution)
    test_execution.pid = pid
    test_execution.save
  end

  def zip_output_files(folder)
    begin
      zipfile_name = "./#{folder}/tmp.zip"
      Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
        Dir["./#{folder}/*"].each do |file|
          zipfile.add(file.sub("./#{folder}/", ''), file)
        end
      end
    rescue => e
      message = "Zipping content of folder '#{folder}' failed with message #{e.inspect}"
      p message
      $logger.error(message)
    end

    zipfile_name
  end

  def save_zip_file(zipped_file, test_execution)
    begin
      file = File.open(zipped_file)
      encoded_zip = Base64.encode64(file.read)
      file.close
      test_execution.output_zip_base64 = encoded_zip
      test_execution.save
    rescue => e
      message = "Saving zip file '#{zipped_file}' failed with message #{e.inspect}"
      p message
      $logger.error(message)
    end
  end

  def delete_folder(folder)
    begin
      FileUtils.rm_rf(folder)
    rescue => e
      message = "Deleting folder '#{folder}' failed with message #{e.inspect}"
      p message
      $logger.info(message)
    end
  end

end
