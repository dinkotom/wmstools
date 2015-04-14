# start mailcatcher before running in development mode
Mail.defaults do
  delivery_method :smtp, :address => 'localhost',
                  :port => 1025
end

set :bind, '0.0.0.0'

DATA_SOURCE = 'mysql://wmsuser:SalvatorDali01@localhost/wmstools_staging'
PORT = 8088
PERFORMANCE_TEST_RESULTS_PER_PAGE = 30

FORTUM_REGRESSION_TESTS_JOB = {
    :cron => '0 * * * *',
    :suites_environments =>
        [
            {:suite => '[F] MAINTENANCE TESTS', :enviroment => 'FAT'},
            {:suite => '[F] SMOKE TESTS', :enviroment => 'FAT4'},
        ]
}

PROMETERA_PERFORMANCE_TESTS_JOB = {
    :cron => '/10 18-21,02-05 * * *',
    :suites_environments =>
        [
            {:suite => '[P] PERFORMANCE TESTS 1', :enviroment => 'PROMETERA'},
            #{:suite => '[P] PERFORMANCE TESTS 2', :enviroment => 'PROMETERA'},
	          {:suite => '[P] PERFORMANCE TESTS 3', :enviroment => 'PROMETERA'},
        ]
}

# everything below this should be the same for both production and development

# everything below this should be the same for both production and development

TEST_SUITES = [
    {:name => '[F] SMOKE TESTS', :type => 'Suite', :environments => ['FAT', 'FAT4', 'FAT5', 'DEV1'], :piazza => true, :default_number_of_tests => 2, :priority => 1, :soapui_project_file => 'WMS.xml'},
    {:name => '[F] WEB SERVICE TESTS', :type => 'Suite', :environments => ['FAT', 'FAT4', 'FAT5', 'DEV1'], :piazza => true, :default_number_of_tests => 5, :priority => 2, :soapui_project_file => 'WMS.xml'},
    {:name => '[F] REGRESSION TESTS 1', :type => 'Suite', :environments => ['FAT', 'FAT4', 'FAT5', 'DEV1'], :piazza => true, :default_number_of_tests => 30, :priority => 3, :soapui_project_file => 'WMS.xml'},
    {:name => '[F] REGRESSION TESTS 2', :type => 'Suite', :environments => ['FAT', 'FAT4', 'FAT5', 'DEV1'], :piazza => true, :default_number_of_tests => 32, :priority => 4, :soapui_project_file => 'WMS.xml'},
    {:name => '[F] REGRESSION TESTS 3', :type => 'Suite', :environments => ['FAT', 'FAT4', 'FAT5', 'DEV1'], :piazza => true, :default_number_of_tests => 22, :priority => 5, :soapui_project_file => 'WMS.xml'},
    {:name => '[F] REGRESSION TESTS 4', :type => 'Suite', :environments => ['FAT', 'FAT4', 'FAT5', 'DEV1'], :piazza => true, :default_number_of_tests => 18, :priority => 6, :soapui_project_file => 'WMS.xml'},
    {:name => '[F] REGRESSION TESTS 5', :type => 'Suite', :environments => ['FAT', 'FAT4', 'FAT5', 'DEV1'], :piazza => true, :default_number_of_tests => 17, :priority => 7, :soapui_project_file => 'WMS.xml'},
    {:name => '[F] REGRESSION TESTS 6', :type => 'Suite', :environments => ['FAT', 'FAT4', 'FAT5', 'DEV1'], :piazza => true, :default_number_of_tests => 24, :priority => 8, :soapui_project_file => 'WMS.xml'},
    {:name => '[F] REGRESSION TESTS 7', :type => 'Suite', :environments => ['FAT'], :piazza => true, :default_number_of_tests => 5, :priority => 9, :soapui_project_file => 'WMS.xml'},
    {:name => '[F] LOAD TESTS', :type => 'Suite', :environments => ['FAT', 'FAT4', 'FAT5', 'DEV1'], :piazza => false, :priority => 10, :soapui_project_file => 'WMS.xml', :load => true},
    {:name => '[F] MAINTENANCE TESTS', :type => 'Suite', :environments => ['FAT', 'FAT4', 'FAT5', 'DEV1'], :piazza => false, :priority => 11, :soapui_project_file => 'WMS.xml'},
    {:name => '[F] PERFORMANCE TESTS', :type => 'Suite', :environments => ['FAT', 'FAT4', 'FAT5', 'DEV1'], :piazza => false, :priority => 12, :soapui_project_file => 'WMS.xml', :performance => true},
    {:name => '[P] PERFORMANCE TESTS 1 [for FF]', :type => 'Suite', :environments => ['PROMETERA'], :piazza => false, :default_number_of_tests => 1, :priority => 12, :soapui_project_file => 'PrometeraPerformanceGUITest-soapui-project.xml', :performance => true},
    {:name => '[P] PERFORMANCE TESTS 2 [for FF]', :type => 'Suite', :environments => ['PROMETERA'], :piazza => false, :default_number_of_tests => 1, :priority => 13, :soapui_project_file => 'PrometeraPerformanceGUITest-soapui-project.xml', :performance => true},
    {:name => '[P] PERFORMANCE TESTS 3 [for FF]', :type => 'Suite', :environments => ['PROMETERA'], :piazza => false, :default_number_of_tests => 1, :priority => 14, :soapui_project_file => 'PrometeraPerformanceGUITest-soapui-project.xml', :performance => true},
    {:name => '[P] PERFORMANCE TESTS 4 [for IE]', :type => 'Suite', :environments => ['PROMETERA'], :piazza => false, :default_number_of_tests => 1, :priority => 14, :soapui_project_file => 'PrometeraPerformanceGUITest-soapui-project.xml', :performance => true},
    {:name => '[F] BUFFER TESTS', :type => 'Suite', :environments => ['FAT', 'FAT4', 'DEV1'], :piazza => false, :default_number_of_tests => 4, :priority => 99, :soapui_project_file => 'WMS.xml', :buffer => true},
    {:name => '[P] REGRESSION TESTS 1', :type => 'Suite', :environments => ['DEV9PROM'], :piazza => true, :default_number_of_tests => 10, :priority => 15, :soapui_project_file => 'Prometera-soapui-project.xml'},
    {:name => '[P] REGRESSION TESTS 2', :type => 'Suite', :environments => ['DEV9PROM'], :piazza => true, :default_number_of_tests => 10, :priority => 16, :soapui_project_file => 'Prometera-soapui-project.xml'},
    {:name => '[S] RT1 [NEWDELIVERYPOINT]', :type => 'Suite', :environments => ['DEV2SKA'], :piazza => false, :default_number_of_tests => 5, :priority => 26, :soapui_project_file => 'SKAGERAK-REST-soapui-project.xml'},
    {:name => '[S] RT2 [METER CHANGE]', :type => 'Suite', :environments => ['DEV2SKA'], :piazza => false, :default_number_of_tests => 5, :priority => 27, :soapui_project_file => 'SKAGERAK-REST-soapui-project.xml'},
    {:name => '[S] RT3 [RECONNECTION]', :type => 'Suite', :environments => ['DEV2SKA'], :piazza => false, :default_number_of_tests => 1, :priority => 28, :soapui_project_file => 'SKAGERAK-REST-soapui-project.xml'},
    {:name => '[S] RT4 [DISCONNECTION]', :type => 'Suite', :environments => ['DEV2SKA'], :piazza => false, :default_number_of_tests => 1, :priority => 29, :soapui_project_file => 'SKAGERAK-REST-soapui-project.xml'},
    {:name => '[S] RT5 [NEWDELIVERYPOINT_PREQUALIFIED]', :type => 'Suite', :environments => ['DEV2SKA'], :piazza => false, :default_number_of_tests => 1, :priority => 30, :soapui_project_file => 'SKAGERAK-REST-soapui-project.xml'},
    {:name => '[S] RT6 [JMS EXECUTE WORK FLOW INFORMATION]', :type => 'Suite', :environments => ['DEV2SKA'], :piazza => false, :default_number_of_tests => 8, :priority => 31, :soapui_project_file => 'SKAGERAK-REST-soapui-project.xml'},
    {:name => '[S] TRANSLATION TESTS', :type => 'Suite', :environments => ['DEV2SKA'], :piazza => false, :default_number_of_tests => 1, :priority => 19, :soapui_project_file => 'Ska-Translation-soapui-project.xml'},
    {:name => '[AM] SMOKE TESTS', :type => 'Suite', :environments => ['DEV7'], :piazza => true, :default_number_of_tests => 1, :priority => 20, :soapui_project_file => 'ASSET_MANAGEMENT-GUI.xml'},
    {:name => '[AM] REGRESSION TESTS 1', :type => 'Suite', :environments => ['DEV7'], :piazza => true, :default_number_of_tests => 1, :priority => 21, :soapui_project_file => 'ASSET_MANAGEMENT-REST.xml'},
    {:name => '[AM] PERFORMANCE TESTS', :type => 'Suite', :environments => ['DEV7'], :piazza => false, :default_number_of_tests => 3, :priority => 22, :soapui_project_file => 'ASSET_MANAGEMENT-REST.xml', :performance => true},
    {:name => '[S] WEB SERVICE TESTS', :type => 'Suite', :environments => ['DEV2SKA'], :piazza => false, :default_number_of_tests => 1, :priority => 23, :soapui_project_file => 'Skagerak-soapui-project.xml', :performance => true},
    {:name => '[AM] PERFORMANCE TESTS 2 [for IE]', :type => 'Suite', :environments => ['DEV7'], :piazza => false, :default_number_of_tests => 1, :priority => 24, :soapui_project_file => 'ASSET_MANAGEMENT-REST.xml', :performance => true},
    {:name => '[H] REGRESSION TESTS 1', :type => 'Suite', :environments => ['DEVHF02'], :piazza => true, :default_number_of_tests => 3, :priority => 25, :soapui_project_file => 'WMS-AMS.xml'},
    {:name => '[H] BUFFER TESTS', :type => 'Suite', :environments => ['DEVHF02'], :piazza => false, :default_number_of_tests => 2, :priority => 99, :soapui_project_file => 'WMS-AMS.xml', :buffer => true},

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
         '[F] REGRESSION TESTS 6',
         '[F] REGRESSION TESTS 7',
         '[P] REGRESSION TESTS 1',
         '[P] REGRESSION TESTS 2',
         '[S] RT1 [NEWDELIVERYPOINT]',
         '[S] RT2 [METER CHANGE]',
         '[S] RT3 [RECONNECTION]',
         '[S] RT4 [DISCONNECTION]',
         '[S] RT5 [NEWDELIVERYPOINT_PREQUALIFIED]',
         '[S] RT6 [JMS EXECUTE WORK FLOW INFORMATION]',
         '[AM] SMOKE TESTS',
         '[AM] REGRESSION TESTS 1',
         '[H] REGRESSION TESTS 1',
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
    {:name => '[F] REGRESSION TESTS 6',
     :suites => ['[F] REGRESSION TESTS 6'
     ]
    },
    {:name => '[F] REGRESSION TESTS 7',
     :suites => ['[F] REGRESSION TESTS 7'
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
    {:name => '[P] PERFORMANCE TESTS 1 [for FF]',
     :suites => ['[P] PERFORMANCE TESTS 1 [for FF]'
     ]
    },
    {:name => '[P] PERFORMANCE TESTS 2 [for FF]',
     :suites => ['[P] PERFORMANCE TESTS 2 [for FF]'
     ]
    },
    {:name => '[P] PERFORMANCE TESTS 3 [for FF]',
     :suites => ['[P] PERFORMANCE TESTS 3 [for FF]'
     ]
    },
    {:name => '[P] PERFORMANCE TESTS 4 [for IE]',
     :suites => ['[P] PERFORMANCE TESTS 4 [for IE]'
     ]
    },
    {:name => '[F] BUFFER TESTS',
     :suites => ['[F] BUFFER TESTS'
     ]
    },
    {:name => '[P] REGRESSION TESTS 1',
     :suites => ['[P] REGRESSION TESTS 1'
     ]
    },
    {:name => '[P] REGRESSION TESTS 2',
     :suites => ['[P] REGRESSION TESTS 2'
     ]
    },
    #    {:name => '[F] TRANSLATION TESTS',
    #     :suites => ['[F] TRANSLATION TESTS'
    #     ]
    #    },
    {:name => '[S] RT1 [NEWDELIVERYPOINT]',
     :suites => ['[S] RT1 [NEWDELIVERYPOINT]'
     ]
    },
    {:name => '[S] RT2 [METER CHANGE]',
     :suites => ['[S] RT2 [METER CHANGE]'
     ]
    },
    {:name => '[S] RT3 [RECONNECTION]',
     :suites => ['[S] RT3 [RECONNECTION]'
     ]
    },
    {:name => '[S] RT4 [DISCONNECTION]',
     :suites => ['[S] RT4 [DISCONNECTION]'
     ]
    },
    {:name => '[S] RT5 [NEWDELIVERYPOINT_PREQUALIFIED]',
     :suites => ['[S] RT5 [NEWDELIVERYPOINT_PREQUALIFIED]'
     ]
    },
    {:name => '[S] RT6 [JMS EXECUTE WORK FLOW INFORMATION]',
     :suites => ['[S] RT6 [JMS EXECUTE WORK FLOW INFORMATION]',
     ]
    },
    {:name => '[S] TRANSLATION TESTS',
     :suites => ['[S] TRANSLATION TESTS'
     ]
    },
    {:name => '[AM] SMOKE TESTS',
     :suites => ['[AM] SMOKE TESTS'
     ]
    },
    {:name => '[AM] REGRESSION TESTS 1',
     :suites => ['[AM] REGRESSION TESTS 1'
     ]
    },
    {:name => '[AM] PERFORMANCE TESTS',
     :suites => ['[AM] PERFORMANCE TESTS'
     ]
    },
    {:name => '[S] WEB SERVICE TESTS',
     :suites => ['[S] WEB SERVICE TESTS'
     ]
    },
    {:name => '[AM] PERFORMANCE TESTS 2 [for IE]',
     :suites => ['[AM] PERFORMANCE TESTS 2 [for IE]'
     ]
    },
    {:name => '[H] REGRESSION TESTS 1',
     :suites => ['[H] REGRESSION TESTS 1'
     ]
    },
    {:name => '[H] BUFFER TESTS',
     :suites => ['[H] BUFFER TESTS'
     ]
    },
]

PERFORMANCE_TESTS = [
    {:test_suite_name => '[F] PERFORMANCE TESTS', :performance_measurement_points => [
        {:id => 'PERF001', :name => 'Create errand', :reference_value => 16000, :max_value => 20000},
        {:id => 'PERF002', :name => 'Add tariff', :reference_value => 550, :max_value => 2000},
        {:id => 'PERF003', :name => 'Create WO175', :reference_value => 6800, :max_value => 10000},
        {:id => 'PERF004', :name => 'Send ACK', :reference_value => 4500, :max_value => 10000},
        {:id => 'PERF005', :name => 'Report WO175', :reference_value => 31500, :max_value => 45000},
        {:id => 'PERF006', :name => 'Report WO235', :reference_value => 16000, :max_value => 25000},
        {:id => 'PERF007', :name => 'Report WO203', :reference_value => 13000, :max_value => 20000},
    ]
    },
    {:test_suite_name => '[P] PERFORMANCE TESTS 1 [for FF]', :performance_measurement_points => [
        {:id => 'PERF001', :name => 'Login', :reference_value => 5048, :max_value => 6500},
        {:id => 'PERF002', :name => 'Click on Home Link', :reference_value => 3489, :max_value => 5000},
        {:id => 'PERF003', :name => 'Fetch errand', :reference_value => 12480, :max_value => 13000},
        {:id => 'PERF004', :name => 'Open Milstopar', :reference_value => 2298, :max_value => 4500},
        {:id => 'PERF005', :name => 'Open Aktiviteter', :reference_value => 1129, :max_value => 2500},
        {:id => 'PERF006', :name => 'Open Fel PO', :reference_value => 1057, :max_value => 2500},
        {:id => 'PERF007', :name => 'Open Checklistor', :reference_value => 1022, :max_value => 2500},
        {:id => 'PERF008', :name => 'Open Arbetsordrar', :reference_value => 1049, :max_value => 2500},
        {:id => 'PERF009', :name => 'Open Tidslage', :reference_value => 1763, :max_value => 3000},
        {:id => 'PERF010', :name => 'Open Document', :reference_value => 800, :max_value => 1200},
        {:id => 'PERF011', :name => 'Open Timestamps', :reference_value => 3238, :max_value => 4750},
    ]
    },
    {:test_suite_name => '[P] PERFORMANCE TESTS 2 [for FF]', :performance_measurement_points => [
        {:id => 'PERF001', :name => 'Login to Prometera', :reference_value => 2876, :max_value => 4000},
        {:id => 'PERF002', :name => 'Create Errand', :reference_value => 2733, :max_value => 4500},
        {:id => 'PERF003', :name => 'Create Work Order', :reference_value => 7963, :max_value => 8500},
        {:id => 'PERF004', :name => 'Show activity delivery site', :reference_value => 8540, :max_value => 10000},
        {:id => 'PERF005', :name => 'Fetch Delivery site id', :reference_value => 8540, :max_value => 10000},
        {:id => 'PERF006', :name => 'Save delivery site', :reference_value => 1556, :max_value => 3000},
        {:id => 'PERF007', :name => 'Show activity meter', :reference_value => 1763, :max_value => 3000},
        {:id => 'PERF008', :name => 'Fetch meter id', :reference_value => 940, :max_value => 2000},
        {:id => 'PERF009', :name => 'Save meter', :reference_value => 940, :max_value => 2000},
    ]
    },
    {:test_suite_name => '[P] PERFORMANCE TESTS 3 [for FF]', :performance_measurement_points => [
        {:id => 'PERF001', :name => 'Create Errand Frankoppling', :reference_value => 3500, :max_value => 4500},
        {:id => 'PERF002', :name => 'Create Errand Felsokning & underhall', :reference_value => 3500, :max_value => 4500},
        {:id => 'PERF003', :name => 'Create Errand Matarbyte', :reference_value => 3500, :max_value => 4500},
        {:id => 'PERF004', :name => 'Create Errand Ny matpunkt', :reference_value => 3500, :max_value => 4500},
        {:id => 'PERF005', :name => 'Create Errand Aterinkoppling', :reference_value => 3500, :max_value => 4500},
        {:id => 'PERF006', :name => 'Create Errand Avslutning', :reference_value => 3500, :max_value => 4500},
        {:id => 'PERF007', :name => 'Create Errand Verifiering', :reference_value => 3500, :max_value => 4500},
    ]
    },
    {:test_suite_name => '[P] PERFORMANCE TESTS 4 [for IE]', :performance_measurement_points => [
        {:id => 'PERF001', :name => 'Login', :reference_value => 1200, :max_value => 2500},
        {:id => 'PERF002', :name => 'Click on Home Link', :reference_value => 1200, :max_value => 2500},
        {:id => 'PERF003', :name => 'Fetch errand', :reference_value => 4000, :max_value => 5500},
        {:id => 'PERF004', :name => 'Open Milstopar', :reference_value => 1200, :max_value => 2500},
        {:id => 'PERF005', :name => 'Open Aktiviteter', :reference_value => 1200, :max_value => 2500},
        {:id => 'PERF006', :name => 'Open Fel PO', :reference_value => 1200, :max_value => 2500},
        {:id => 'PERF007', :name => 'Open Checklistor', :reference_value => 1200, :max_value => 2500},
        {:id => 'PERF008', :name => 'Open Arbetsordrar', :reference_value => 1200, :max_value => 2500},
        {:id => 'PERF009', :name => 'Open Tidslage', :reference_value => 1200, :max_value => 2500},
        {:id => 'PERF010', :name => 'Open Document', :reference_value => 1200, :max_value => 2500},
        {:id => 'PERF011', :name => 'Open Timestamps', :reference_value => 1200, :max_value => 2500},
    ]
    },
    {:test_suite_name => '[AM] PERFORMANCE TESTS', :performance_measurement_points => [
        {:id => 'PERF001', :name => 'Get unique devices DB', :reference_value => 500, :max_value => 2000},
        {:id => 'PERF002', :name => 'Get unique devices REST', :reference_value => 1000, :max_value => 4000},
        {:id => 'PERF003', :name => 'Get unique devices GUI', :reference_value => 15000, :max_value => 30000},
    ]
    },
    {:test_suite_name => '[AM] PERFORMANCE TESTS 2 [for IE]', :performance_measurement_points => [
        {:id => 'PERF001', :name => 'Search all', :reference_value => 15000, :max_value => 20000},
        {:id => 'PERF002', :name => 'Search asset number', :reference_value => 15000, :max_value => 20000},
        {:id => 'PERF003', :name => 'Search asset template', :reference_value => 15000, :max_value => 20000},
        {:id => 'PERF004', :name => 'Add search all', :reference_value => 15000, :max_value => 20000},
        {:id => 'PERF005', :name => 'Overview search all', :reference_value => 15000, :max_value => 20000},
    ]
    },
]

PIAZZA_SCREENS = [
    {:screen_number => 1, :environments => ['FAT4']},
    {:screen_number => 2, :environments => ['FAT']},
    {:screen_number => 3, :environments => ['DEV7']},
    {:screen_number => 4, :environments => ['DEVHF02']},
]

DELIVERY_SITE_TYPES = [
    {:id => '[F] M1 1C', :name => '[F] M1 1C', :environments => ['FAT', 'FAT4', 'FAT5', 'DEV1'], :test_suite_name => '[F] BUFFER TESTS', :quota => 50},
    {:id => '[F] M1 1C RDR', :name => '[F] M1 1C RDR', :environments => ['FAT', 'FAT4', 'FAT5', 'DEV1'], :test_suite_name => '[F] BUFFER TESTS', :quota => 50},
    {:id => '[F] M1 2C', :name => '[F] M1 2C', :environments => ['FAT', 'FAT4', 'FAT5', 'DEV1'], :test_suite_name => '[F] BUFFER TESTS', :quota => 50},
    {:id => '[F] T7 1C', :name => '[F] T7 1C', :environments => ['FAT', 'FAT4', 'FAT5', 'DEV1'], :test_suite_name => '[F] BUFFER TESTS', :quota => 50},
    {:id => '[F] T1 1C', :name => '[F] T1 1C', :environments => ['FAT', 'FAT4', 'FAT5', 'DEV1'], :test_suite_name => '[F] BUFFER TESTS', :quota => 50},
    {:id => '[F] T1 2C', :name => '[F] T1 2C', :environments => ['FAT', 'FAT4', 'FAT5', 'DEV1'], :test_suite_name => '[F] BUFFER TESTS', :quota => 50},
    {:id => '[F] T1 4C', :name => '[F] T1 4C', :environments => ['FAT', 'FAT4'], :test_suite_name => '[F] BUFFER TESTS', :quota => 50},
    {:id => '[S] SKA REG', :name => '[S] Regular', :environments => ['DEV2SKA'], :quota => 0},
    {:id => '[S] SKA REG + TRA', :name => '[S] Regular + Trafo', :environments => ['DEV2SKA'], :quota => 0},
    {:id => '[S] SKA REG DISC', :name => '[S] Regular - Disconnected', :environments => ['DEV2SKA'], :quota => 0},
    {:id => '[S] SKA REG DISC + TRA', :name => '[S] Regular - Disconnected + Trafo', :environments => ['DEV2SKA'],:quota => 0},
    {:id => '[S] SKA HOUR', :name => '[S] Hourly', :environments => ['DEV2SKA'], :quota => 0},
    {:id => '[S] SKA HOUR + TRAFO', :name => '[S] Hourly + Trafo', :environments => ['DEV2SKA'], :quota => 0},
    {:id => '[H] AMS Z31 1c', :name => '[H] AMS Z31 1c', :environments => ['DEVHF02'], :test_suite_name => '[H] BUFFER TESTS', :quota => 999},
    {:id => '[H] AMS Z31 2c', :name => '[H] AMS Z31 2c', :environments => ['DEVHF02'], :test_suite_name => '[H] BUFFER TESTS', :quota => 500},
]

ENVIRONMENTS = [
    {:name => 'FAT5', :wms_version => '4.8.0'},
    {:name => 'FAT4', :wms_version => '4.8.2'},
    {:name => 'FAT', :wms_version => '4.8.9'},
    {:name => 'PROMETERA', :wms_version => '4.8.9'},
    {:name => 'DEV1', :wms_version => '4.8.2DEV'},
    {:name => 'DEV9PROM', :wms_version => '4.8.9'},
    {:name => 'DEV2SKA', :wms_version => '4.8.9'},
    {:name => 'DEV7', :wms_version => '4.8.9'},
    {:name => 'DEVHF02', :wms_version => '4.8.9'},

]
