Mail.defaults do
  delivery_method :test
end

DATA_SOURCE = 'sqlite::memory:'
PORT = 8080
PERFORMANCE_TEST_RESULTS_PER_PAGE = 3

TEST_SUITES = [
    {:name => '[F] SMOKE TESTS', :type => 'Suite', :environments => ['FAT', 'FAT4'], :piazza => true, :default_number_of_tests => 1, :priority => 1, :soapui_project_file => 'WMS.xml'},
    {:name => '[F] WEB SERVICE TESTS', :type => 'Suite', :environments => ['FAT', 'FAT4'], :piazza => true, :default_number_of_tests => 5, :priority => 2, :soapui_project_file => 'WMS.xml'},
    {:name => '[F] REGRESSION TESTS 1', :type => 'Suite', :environments => ['FAT', 'FAT4'], :piazza => true, :default_number_of_tests => 30, :priority => 3, :soapui_project_file => 'WMS.xml'},
    {:name => '[F] REGRESSION TESTS 2', :type => 'Suite', :environments => ['FAT', 'FAT4'], :piazza => true, :default_number_of_tests => 30, :priority => 4, :soapui_project_file => 'WMS.xml'},
    {:name => '[F] REGRESSION TESTS 3', :type => 'Suite', :environments => ['FAT', 'FAT4'], :piazza => true, :default_number_of_tests => 30, :priority => 5, :soapui_project_file => 'WMS.xml'},
    {:name => '[F] REGRESSION TESTS 4', :type => 'Suite', :environments => ['FAT'], :piazza => true, :default_number_of_tests => 30, :priority => 6, :soapui_project_file => 'WMS.xml'},
    {:name => '[F] REGRESSION TESTS 5', :type => 'Suite', :environments => ['FAT'], :piazza => true, :default_number_of_tests => 30, :priority => 6, :soapui_project_file => 'WMS.xml'},
    {:name => '[F] LOAD TESTS', :type => 'Suite', :environments => ['FAT', 'FAT4'], :piazza => false, :priority => 7, :soapui_project_file => 'WMS.xml', :load => true},
    {:name => '[F] MAINTENANCE TESTS', :type => 'Suite', :environments => ['FAT', 'FAT4'], :piazza => false, :priority => 8, :soapui_project_file => 'WMS.xml'},
    {:name => '[F] PERFORMANCE TESTS', :type => 'Suite', :environments => ['FAT', 'FAT4'], :piazza => false, :priority => 9, :soapui_project_file => 'WMS.xml', :performance => true},
    {:name => '[H] REGRESSION TESTS 1', :type => 'Suite', :environments => ['DEVHF01'], :piazza => true, :default_number_of_tests => 4, :priority => 10, :soapui_project_file => 'WMS.xml'},
    {:name => '[H] PERFORMANCE TESTS', :type => 'Suite', :environments => ['DEVHF01'], :piazza => true, :default_number_of_tests => 4, :priority => 11, :soapui_project_file => 'WMS.xml', :performance => true},
    {:name => '[P] PERFORMANCE TESTS 1', :type => 'Suite', :environments => ['PROMETERA'], :piazza => true, :default_number_of_tests => 4, :priority => 11, :soapui_project_file => 'WMS_Prometera.xml', :performace => true},
    {:name => '[P] PERFORMANCE TESTS 2', :type => 'Suite', :environments => ['PROMETERA'], :piazza => true, :default_number_of_tests => 4, :priority => 11, :soapui_project_file => 'WMS_Prometera.xml', :performace => true},
    {:name => '[F] BUFFER TESTS', :type => 'Suite', :environments => ['FAT', 'FAT4'], :piazza => false, :default_number_of_tests => 4, :priority => 11, :soapui_project_file => 'WMS.xml', :buffer => true},
    {:name => '[H] BUFFER TESTS', :type => 'Suite', :environments => ['DEVHF01'], :piazza => false, :default_number_of_tests => 4, :priority => 11, :soapui_project_file => 'WMS_Hafslund.xml', :buffer => true},

]

TEST_PACKAGES = [
    {:name => 'FULL REGRESSION TEST',
     :suites => [
         '[F] SMOKE TESTS',
         '[F] WEB SERVICE TESTS',
         '[F] REGRESSION TESTS 1',
         '[F] REGRESSION TESTS 2',
         '[F] REGRESSION TESTS 3',
         '[F] REGRESSION TESTS 4',
         '[F] REGRESSION TESTS 5',
     ]
    },
    {:name => '[F] SMOKE TESTS',
     :suites => [
         '[F] SMOKE TESTS'
     ]
    },
    {:name => '[F] REGRESSION TESTS 1',
     :suites => ['[F] REGRESSION TESTS 1'
     ]
    },
    {:name => '[F] REGRESSION TESTS 2',
     :suites => ['[F] REGRESSION TESTS 2'
     ]
    },
    {:name => '[F] REGRESSION TESTS 3',
     :suites => ['[F] REGRESSION TESTS 3'
     ]
    },
    {:name => '[F] REGRESSION TESTS 4',
     :suites => ['[F] REGRESSION TESTS 4'
     ]
    },
    {:name => '[F] REGRESSION TESTS 5',
     :suites => ['[F] REGRESSION TESTS 5'
     ]
    },
    {:name => '[H] REGRESSION TESTS 1',
     :suites => ['[H] REGRESSION TESTS 1'
     ]
    },
    {:name => '[F] LOAD TESTS',
     :suites => ['[F] LOAD TESTS'
     ]
    },
    {:name => '[F] MAINTENANCE TESTS',
     :suites => ['[F] MAINTENANCE TESTS'
     ]
    },
    {:name => '[F] WEB SERVICE TESTS',
     :suites => ['[F] WEB SERVICE TESTS'
     ]
    },
    {:name => '[F] PERFORMANCE TESTS',
     :suites => ['[F] PERFORMANCE TESTS'
     ]
    },
    {:name => '[P] PERFORMANCE TESTS 1',
     :suites => ['[P] PERFORMANCE TESTS 1'
     ]
    },
    {:name => '[P] PERFORMANCE TESTS 2',
     :suites => ['[P] PERFORMANCE TESTS 2'
     ]
    },
    {:name => '[F] BUFFER TESTS',
     :suites => ['[F] BUFFER TESTS'
     ]
    },
]

PERFORMANCE_TESTS = [
    {:test_suite_name => '[F] PERFORMANCE TESTS', :performance_measurement_points => [
        {:id => 'PERF001', :name => 'create WO', :reference_value => 2100},
        {:id => 'PERF002', :name => 'report WO', :reference_value => 25},
        {:id => 'PERF002b', :name => 'cancel errand', :reference_value => 100500},
        {:id => 'PERF003', :name => 'regret errand', :reference_value => 800},
        {:id => 'PERF004', :name => 'import meter reading', :reference_value => 12000},
    ]
    },
    {:test_suite_name => '[P] PERFORMANCE TESTS 1', :performance_measurement_points => [
        {:id => 'PERF001', :name => 'get errand', :reference_value => 100},
        {:id => 'PERF002', :name => 'get delivery site data', :reference_value => 250},
    ]
    },
    {:test_suite_name => '[H] PERFORMANCE TESTS', :performance_measurement_points => [
        {:id => 'PERF001', :name => 'Connect Meter', :reference_value => 180, :max_value => 250},
        {:id => 'PERF002', :name => 'Activate Meter Change', :reference_value => 2500, :max_value => 3500},
        {:id => 'PERF003', :name => 'Total', :reference_value => 422500, :max_value => 425000},
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
    {:screen_number => 1, :environments => ['FAT4', 'DEVHF01']},
    {:screen_number => 2, :environments => ['FAT']}
]

FORTUM_REGRESSION_TESTS_JOB = {
    :cron => '* * * * *',
    :suites_environments =>
        [
            {:suite => '[F] MAINTENANCE TESTS', :enviroment => 'FAT'},
            {:suite => '[F] SMOKE TESTS', :enviroment => 'FAT4'},
        ]
}

DELIVERY_SITE_TYPES = [
    {:id => 'type1', :name => 'Delivery site type 1', :environments => ['FAT', 'FAT4'], :test_suite_name => '[F] BUFFER TESTS', :quota => 6},
    {:id => 'type2', :name => 'Delivery site type 2', :environments => ['FAT', 'FAT4'], :test_suite_name => '[F] BUFFER TESTS', :quota => 2},
    {:id => 'type3', :name => 'Delivery site type 3', :environments => ['FAT'], :test_suite_name => '[F] BUFFER TESTS', :quota => 5},
    {:id => 'type4manual', :name => 'Manually buffered delivery site', :environments => ['FAT'], :quota => 0},
    {:id => 'type5', :name => 'Delivery site type 5 - Hafslund', :environments => ['DEVHF01'], :test_suite_name => '[H] BUFFER TESTS', :quota => 5},
]

ENVIRONMENTS = [
    {:name => 'FAT4', :wms_version => '4.9.0'},
    {:name => 'FAT', :wms_version => '4.9.0'},
    {:name => 'TINA1', :wms_version => '4.9.0'},
    {:name => 'PROMETERA', :wms_version => '4.9.0'},
    {:name => 'DEVHF01', :wms_version => '4.9.0'},
]

