Bundler.require(:test)
require_relative('../agent/operating_system')
require_relative('../agent/config/conf_test')
require_relative('../test/setup_tests')

class TestOs < Test::Unit::TestCase

  def setup
    @stdout_start = %q{
      2014-12-02 08:00:44,733 INFO  [SoapUI] Adding [/home/nodeTest/work/svn/trunk/requiredJARs/prometeraTAPerformance.jar] to extensions classpath
      2014-12-02 08:00:44,743 INFO  [SoapUI] Adding [/home/nodeTest/work/svn/trunk/requiredJARs/inject-1.4-SNAPSHOT.jar] to extensions classpath
      2014-12-02 08:00:44,743 INFO  [SoapUI] Adding [/home/nodeTest/work/svn/trunk/requiredJARs/messageHandler-trunk-SNAPSHOT.jar] to extensions classpath
      2014-12-02 08:00:44,743 INFO  [SoapUI] Adding [/home/nodeTest/work/svn/trunk/requiredJARs/goodies2.jar] to extensions classpath
      2014-12-02 08:00:44,744 INFO  [SoapUI] Adding [/home/nodeTest/work/svn/trunk/requiredJARs/domain-model-trunk-SNAPSHOT.jar] to extensions classpath
      2014-12-02 08:00:44,745 INFO  [SoapUI] Adding [/home/nodeTest/work/svn/trunk/requiredJARs/castor-1.0.1.jar] to extensions classpath
      2014-12-02 08:00:44,745 INFO  [SoapUI] Adding [/home/nodeTest/work/svn/trunk/requiredJARs/ini4j-0.5.2.jar] to extensions classpath
      2014-12-02 08:00:44,745 INFO  [SoapUI] Adding [/home/nodeTest/work/svn/trunk/requiredJARs/bsf-2.4.0.jar] to extensions classpath
      2014-12-02 08:00:44,746 INFO  [SoapUI] Adding [/home/nodeTest/work/svn/trunk/requiredJARs/ivy-2.2.0.jar] to extensions classpath
      2014-12-02 08:00:44,746 INFO  [SoapUI] Adding [/home/nodeTest/work/svn/trunk/requiredJARs/language-core-2.0.3.jar] to extensions classpath
      2014-12-02 08:00:44,746 INFO  [SoapUI] Adding [/home/nodeTest/work/svn/trunk/requiredJARs/oc4jclient-10.1.3.5.0.jar] to extensions classpath
      2014-12-02 08:00:44,747 INFO  [SoapUI] Adding [/home/nodeTest/work/svn/trunk/requiredJARs/ojdl-1.0.0.jar] to extensions classpath
      2014-12-02 08:00:44,747 INFO  [SoapUI] Adding [/home/nodeTest/work/svn/trunk/requiredJARs/selenium-server-standalone-2.39.0.jar] to extensions classpath
      2014-12-02 08:00:44,748 INFO  [SoapUI] Adding [/home/nodeTest/work/svn/trunk/requiredJARs/jaxb-api-2.1.jar] to extensions classpath
      2014-12-02 08:00:44,748 INFO  [SoapUI] Adding [/home/nodeTest/work/svn/trunk/requiredJARs/com.mysql.jdbc_5.1.5.jar] to extensions classpath
      2014-12-02 08:00:44,748 INFO  [SoapUI] Adding [/home/nodeTest/work/svn/trunk/requiredJARs/j2ee-1.3.0.jar] to extensions classpath
      2014-12-02 08:00:44,749 INFO  [SoapUI] Adding [/home/nodeTest/work/svn/trunk/requiredJARs/ivy-2.2.0-sources.jar] to extensions classpath
      2014-12-02 08:00:44,749 INFO  [SoapUI] Adding [/home/nodeTest/work/svn/trunk/requiredJARs/ojdbc6-11.2.0.3.jar] to extensions classpath
      2014-12-02 08:00:44,749 INFO  [SoapUI] Adding [/home/nodeTest/work/svn/trunk/requiredJARs/javax.inject-1.jar] to extensions classpath
      2014-12-02 08:00:44,750 INFO  [SoapUI] Adding [/home/nodeTest/work/svn/trunk/requiredJARs/stax-api-1.0-2.jar] to extensions classpath
      2014-12-02 08:00:44,750 INFO  [SoapUI] Adding [/home/nodeTest/work/svn/trunk/requiredJARs/casemodel-trunk-SNAPSHOT.jar] to extensions classpath
      2014-12-02 08:00:44,750 INFO  [SoapUI] Adding [/home/nodeTest/work/svn/trunk/requiredJARs/cdi-light-1.4.1.jar] to extensions classpath
      2014-12-02 08:00:44,751 INFO  [SoapUI] Adding [/home/nodeTest/work/svn/trunk/requiredJARs/WMSApplicationEJB-trunk-SNAPSHOT.jar] to extensions classpath
      2014-12-02 08:00:44,751 INFO  [SoapUI] Adding [/home/nodeTest/work/svn/trunk/requiredJARs/mq-6.0.2.5.jar] to extensions classpath
      2014-12-02 08:00:44,751 INFO  [SoapUI] Adding [/home/nodeTest/work/svn/trunk/requiredJARs/casehandling-trunk-SNAPSHOT.jar] to extensions classpath
      2014-12-02 08:00:44,752 INFO  [DefaultSoapUICore] Creating new settings at [/home/nodeTest/soapui-settings.xml]
      2014-12-02 08:00:48,338 INFO  [WsdlProject] Loaded project from [file:/home/nodeTest/work/svn/trunk/WMS.xml]
      2014-12-02 08:01:02,356 INFO  [SoapUITestCaseRunner] Running SoapUI tests in project [WMS Regression tests]
      2014-12-02 08:01:02,360 INFO  [SoapUITestCaseRunner] Running TestSuite [[F] WEB SERVICE TESTS], runType = SEQUENTIAL
      2014-12-02 08:01:03,190 INFO  [SoapUITestCaseRunner] Running SoapUI testcase [get WMS version]
    }

    @stdout_failed = %q{
      [TC109] Disconnection debt collection [basic] FAILED for DS 735999102110642500
      [TC109] Disconnection debt collection [basic] failed, exporting to [/home/bufferThree/F_REGRESSION_TESTS_4-TS012_HARLEYNOselfReadYes_various-TC109_Disconnection_debt_collection_basic-0-FAILED.txt]
      [TC113] Delivery site changes [twoCounter] FAILED for DS 735999102110642555
      [TC113] Delivery site changes [twoCounter] failed, exporting to [/home/bufferThree/F_REGRESSION_TESTS_4-TS013_HARLEYNOselfReadYes_basic-TC113_Delivery_site_changes_twoCounter-0-FAILED.txt]
      [TC005] [P] New delivery site [basic] PASSED for DS 735999102110642463
      [TC023] Hourly collection [basic] PASSED for DS 735999102110642463
      [PERF001][180]
      [TC087] Disconnection no customer [basic] PASSED for DS 735999102110642463
      [PERF001b][10]
      [TC097] New Harley delivery site [basic] PASSED for DS 735999102110642500
      [PERF002][154454]
      [TC102] New Harley delivery site [cancel accept] PASSED for DS 735999102110642524
      [TC098] New Harley delivery site [twoCounter] PASSED for DS 735999102110642555
      [TC200] [P] New delivery site [basic] PASSED for DS 735999102110642593
      [TC094] Termination [notPerformed notFinished] PASSED for DS 735999102110642593
      [TC071] Manual reconnection [basic] PASSED for DS 735999102110642593
      [TC096] AMM meter reading request [cancel triggeredByMoveIn] PASSED for DS 735999102110642593
      [TC079] Manual reconnection [basic RDR SelfReadYes] PASSED for DS 735999102110642593
    }

    @stdout_buffer_failed = %q{
      [TC005] [P] New delivery site [basic] FAILED for DS 735999102110642466
      [TC005] [P] New delivery site [basic] FAILED for DS 735999102110642468
    }

    @stdout_buffer_passed = %q{
      [TC005] [P] New delivery site [basic] PASSED for DS 735999102110642463
      [TC005] [P] New delivery site [basic] PASSED for DS 735999102110642463
      [TC005] [P] New delivery site [basic] PASSED for DS 735999102110642464
      [TC005] [P] New delivery site [basic] PASSED for DS 735999102110642465
      [TC005] [P] New delivery site [basic] PASSED for DS 735999102110642467
      [TC005] [P] New delivery site [basic] PASSED for DS 735999102110642469
    }

    @stdout_finished = @stdout_start + @stdout_failed +  " \n[SoapUITestCaseRunner] Finished running SoapUI tests\n "

    @stdout_performance = %q{
      [TC005] [P] New delivery site [basic] PASSED for DS 735999102110642463
      [TC023] Hourly collection [basic] PASSED for DS 735999102110642463
      [PERF001][180]
      [TC087] Disconnection no customer [basic] PASSED for DS 735999102110642463
      [PERF001b][10]
      [TC097] New Harley delivery site [basic] PASSED for DS 735999102110642500
      [PERF002][154454]
      [TC102] New Harley delivery site [cancel accept] PASSED for DS 735999102110642524
      [TC098] New Harley delivery site [twoCounter] PASSED for DS 735999102110642555
      [TC005] [P] New delivery site [basic] PASSED for DS 735999102110642593
      [TC094] Termination [notPerformed notFinished] PASSED for DS 735999102110642593
      [TC071] Manual reconnection [basic] PASSED for DS 735999102110642593
      [TC096] AMM meter reading request [cancel triggeredByMoveIn] PASSED for DS 735999102110642593
      [TC079] Manual reconnection [basic RDR SelfReadYes] PASSED for DS 735999102110642593
    }

    @os = OperatingSystem.new
    @os.folder, @os.branch, @os.project_file, @os.suite = 'output', 'trunk', 'WMS.xml', '[F] LOAD TEST'

    @te = TestExecution.new
    @te.environment_name = 'FAT'
    @te.test_suite_name = '[F] SMOKE TESTS'

    @te.save
  end

  def test_composing_command
    command = "/usr/bin/java -Xms1024m -Xmx1024m -XX:MaxPermSize=128m -Dsoapui.properties=soapui.properties -Dgroovy.source.encoding=iso-8859-1 -Dsoapui.home=/home/nodeTest/work/soapui/bin -Dsoapui.ext.libraries=/home/nodeTest/work/svn/trunk/requiredJARs -Dsoapui.ext.listeners=/home/nodeTest/work/soapui/bin/listeners -Dsoapui.ext.actions=/home/nodeTest/work/soapui/bin/actions -cp /home/nodeTest/work/soapui/bin/soapui-5.0.0.jar:/home/nodeTest/work/soapui/lib/* com.eviware.soapui.tools.SoapUITestCaseRunner -t /home/nodeTest/work/soapui/soapui-settings.xml -s '[F] LOAD TEST' -r /home/nodeTest/work/svn/trunk/WMS.xml -f 'output' 2> ./output/stderr.txt|tee ./output/stdout.txt"
    assert_equal(command, @os.send(:compose_command))
  end

  def test_composing_load_test_command
    @os.test_case = 'M1 1C'
    command = "/usr/bin/java -Xms1024m -Xmx1024m -XX:MaxPermSize=128m -Dsoapui.properties=soapui.properties -Dgroovy.source.encoding=iso-8859-1 -Dsoapui.home=/home/nodeTest/work/soapui/bin -Dsoapui.ext.libraries=/home/nodeTest/work/svn/trunk/requiredJARs -Dsoapui.ext.listeners=/home/nodeTest/work/soapui/bin/listeners -Dsoapui.ext.actions=/home/nodeTest/work/soapui/bin/actions -cp /home/nodeTest/work/soapui/bin/soapui-5.0.0.jar:/home/nodeTest/work/soapui/lib/* com.eviware.soapui.tools.SoapUITestCaseRunner -t /home/nodeTest/work/soapui/soapui-settings.xml -s '[F] LOAD TEST' -c 'M1 1C' -r /home/nodeTest/work/svn/trunk/WMS.xml -f 'output' 2> ./output/stderr.txt|tee ./output/stdout.txt"
    assert_equal(command, @os.send(:compose_command))
  end

  def test_composing_jar_project_command
    @te.environment_name = 'DEV8'
    @te.test_suite_name = '[P] KAMIL'
    @os.project_file = 'test.jar'
    @os.environment = 'DEV8'
    assert_equal('/usr/bin/java -cp /Users/tdinkov/Git/wmstools/agent/jar_projects/test.jar:/Users/tdinkov/Git/wmstools/agent/jar_projects/lib/* com.tieto.test.ui.demo.Run DEV8 2> ./output/stderr.txt|tee ./output/stdout.txt', @os.send(:compose_command))
  end

  def test_storing_svn_revision
    log = %q{
09:54:51,954 INFO  [SoapUITestCaseRunner] running step [extract version number]
09:54:52,007 INFO  [log] executing against WMS build #62754
09:54:52,007 INFO  [SoapUITestCaseRunner] Finished running SoapUI testcase [get WMS version], time taken: 642ms, status: FINISHED
}
    # line = '2014-11-18 06:38:45,226 INFO  [log] executing against WMS build #53683'

    log.each_line do |line|
      @os.send(:scan_for_svn_revision, line, @te)
    end
    assert_equal('62754', TestExecution.get(@te.id).revision)
  end

  def test_saving_pid
    @os.send(:save_pid, '2587', @te)
    assert_equal('2587', TestExecution.get(@te.id).pid)
  end

  def test_counting_number_of_failed_tests
    @stdout_failed.each_line {|line|@os.send(:scan_for_test_cases, line, @te)}
    assert_equal(2, TestCaseResult.all(:test_execution_id => @te.id, :result => 'FAILED').count)
    @te.destroy!
  end

  def test_no_delivery_sites_are_created_when_test_fails
    DeliverySite.destroy!
    @te.test_suite_name = '[F] BUFFER TESTS'
    @te.delivery_site_type_id = 'type1'
    @stdout_buffer_failed.each_line {|line|@os.send(:scan_for_delivery_sites, line, @te)}
    assert_equal(0, DeliverySite.all.count)
    @te.destroy!
  end

  def test_buffer_test_suite_creates_delivery_sites
    DeliverySite.destroy!
    @te.test_suite_name = '[F] BUFFER TESTS'
    @te.delivery_site_type_id = 'type1'
    @stdout_buffer_passed.each_line { |line| @os.send(:scan_for_delivery_sites, line, @te) }
    assert_equal(5, DeliverySite.all.count)
    @te.destroy!
  end

  def test_turning_status_to_running
    @stdout_start.each_line {|line|@os.send(:scan_for_starting_running, line, @te)}
    assert_equal('Running', @te.status)
  end

  def test_scanning_for_finished_test
    @stdout_finished.each_line {|line|@os.send(:scan_for_finished_running, line, @te)}
    assert_equal('Finalizing', @te.status)
  end

  def test_storing_performance_measurements
    @te.test_suite_name = '[F] PERFORMANCE TESTS'
    @te.save
    PerformanceMeasurement.destroy!
    @stdout_performance.each_line {|line|@os.send(:scan_for_performance_measurements, line, @te)}
    assert_equal(2, PerformanceMeasurement.all.count)
    assert_equal(180, PerformanceMeasurement.get(@te.id, 'PERF001', @te.test_suite_name).value)
    assert_equal(154454, PerformanceMeasurement.get(@te.id, 'PERF002', @te.test_suite_name).value)
  end

end