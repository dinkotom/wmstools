Mail.defaults do
  delivery_method :test
end

DATA_SOURCE = 'sqlite::memory:'
PORT = 8080
PERFORMANCE_TEST_RESULTS_PER_PAGE = 3

TEST_SUITES = [
    {:name => '[F] SMOKE TESTS', :type => 'Suite', :environments => ['FAT', 'FAT4'], :piazza => true, :default_number_of_tests => 1, :priority => 1, :project_file => 'WMS.xml'},
]

TEST_PACKAGES = [
    {:name => 'FULL REGRESSION TEST',
     :suites => [
         '[F] SMOKE TESTS',
     ]
    },
    {:name => '[F] SMOKE TESTS',
     :suites => [
         '[F] SMOKE TESTS'
     ]
    },
]

TEST_EXECUTIONS = [
    {
        :enqueued_at => DateTime.new(2014, 6, 4, 6, 15, 0, '+1'),
        :test_suite_name => '[H] PERFORMANCE TESTS',
        :result => 'PASSED',
        :environment_name => 'DEVHF01'
    },
    {
        :enqueued_at => DateTime.new(2014, 6, 5, 6, 15, 0, '+1'),
        :test_suite_name => '[H] PERFORMANCE TESTS',
        :result => 'PASSED',
        :environment_name => 'DEVHF01'
    },
    {
        :enqueued_at => DateTime.new(2014, 6, 6, 6, 15, 0, '+1'),
        :test_suite_name => '[H] PERFORMANCE TESTS',
        :result => 'PASSED',
        :environment_name => 'DEVHF01'
    },
    {
        :enqueued_at => DateTime.new(2014, 6, 7, 6, 15, 0, '+1'),
        :test_suite_name => '[H] PERFORMANCE TESTS',
        :result => 'PASSED',
        :environment_name => 'DEVHF01'
    },
]

PERFORMANCE_MEASUREMENTS = [
    {
        :test_execution_id => 1,
        :performance_measurement_point_id => 'PERF001',
        :performance_measurement_point_test_suite_name => '[H] PERFORMANCE TESTS',
        :value => 200
    },
    {
        :test_execution_id => 1,
        :performance_measurement_point_id => 'PERF002',
        :performance_measurement_point_test_suite_name => '[H] PERFORMANCE TESTS',
        :value => 2400
    },
    {
        :test_execution_id => 1,
        :performance_measurement_point_id => 'PERF003',
        :performance_measurement_point_test_suite_name => '[H] PERFORMANCE TESTS',
        :value => 420300
    },
    {
        :test_execution_id => 2,
        :performance_measurement_point_id => 'PERF001',
        :performance_measurement_point_test_suite_name => '[H] PERFORMANCE TESTS',
        :value => 180
    },
    {
        :test_execution_id => 2,
        :performance_measurement_point_id => 'PERF002',
        :performance_measurement_point_test_suite_name => '[H] PERFORMANCE TESTS',
        :value => 3600
    },
    {
        :test_execution_id => 3,
        :performance_measurement_point_id => 'PERF003',
        :performance_measurement_point_test_suite_name => '[H] PERFORMANCE TESTS',
        :value => 420300
    },
    {
        :test_execution_id => 4,
        :performance_measurement_point_id => 'PERF001b',
        :performance_measurement_point_test_suite_name => '[H] PERFORMANCE TESTS',
        :value => 10200
    },
]

PIAZZA_SCREENS = [
    {:screen_number => 1, :environments => ['FAT']}
]


DELIVERY_SITE_TYPES = [
    {:id => '[F] M1 1C', :name => '[F] M1 1C', :environments => ['FAT', 'FAT4', 'FAT5', 'FAT12'], :test_suite_name => '[F] BUFFER TESTS', :quota => 2},
]

ENVIRONMENTS = [
    {:name => 'FAT4', :wms_version => 'trunk'},
    {:name => 'FAT', :wms_version => 'trunk'},
    {:name => 'TINA1', :wms_version => 'trunk'},
    {:name => 'PROMETERA', :wms_version => 'trunk'},
    {:name => 'DEVHF01', :wms_version => 'trunk'},
    {:name => 'DEV8', :wms_version => 'trunk'},
]

