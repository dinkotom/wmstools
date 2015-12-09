Mail.defaults do
  delivery_method :smtp, :address => 'inbound.tieto.com',
                  :port => 587,
                  :domain => 'www.tieto.com',
                  :user_name => 'svc_wmsapp',
                  :password => 'Ostrava123456',
                  :authentication => 'login',
                  :enable_starttls_auto => false
end

DATA_SOURCE = 'mysql://wmsuser:SalvatorDali01@localhost/wmstools'
PORT = 80
PERFORMANCE_TEST_RESULTS_PER_PAGE = 30


FORTUM_SMOKE_TESTS_JOB = {
    :cron => '30 4 * * *',
    :suites_environments =>
        [
            {:suite => '[F] SMOKE TESTS', :environment => 'FAT'},
            {:suite => '[F] MAINTENANCE TESTS', :environment => 'FAT'},
            {:suite => '[F] SMOKE TESTS', :environment => 'FAT4'},
            {:suite => '[F] MAINTENANCE TESTS', :environment => 'FAT4'},
            #{:suite => '[F] SMOKE TESTS', :environment => 'FAT5'},
            {:suite => '[F] SMOKE TESTS', :environment => 'FAT12'},
        ]
}


FORTUM_TRUNK_REGRESSION_TESTS_JOB = {
    :cron => '0 5 * * *',
    :suites_environments =>
        [
            {:suite => '[F] SMOKE TESTS', :environment => 'FAT'},
            {:suite => '[F] REGRESSION TESTS 1', :environment => 'FAT'},
            {:suite => '[F] REGRESSION TESTS 2', :environment => 'FAT'},
            {:suite => '[F] REGRESSION TESTS 3', :environment => 'FAT'},
            {:suite => '[F] REGRESSION TESTS 4', :environment => 'FAT'},
            {:suite => '[F] REGRESSION TESTS 5', :environment => 'FAT'},
            {:suite => '[F] REGRESSION TESTS 6', :environment => 'FAT'},
            {:suite => '[F] REGRESSION TESTS 7', :environment => 'FAT'},
            {:suite => '[F] REGRESSION TESTS 8', :environment => 'FAT'},
            {:suite => '[F] REGRESSION TESTS 9', :environment => 'FAT'},
            {:suite => '[F] WEB SERVICE TESTS', :environment => 'FAT'},
        ]
}

#FORTUM_BRANCH_REGRESSION_TESTS_JOB = {
#    :cron => '0 6 * * *',
#    :suites_environments =>
#        [
#            {:suite => '[F] SMOKE TESTS', :environment => 'FAT4'},
#            {:suite => '[F] REGRESSION TESTS 1', :environment => 'FAT4'},
#            {:suite => '[F] REGRESSION TESTS 2', :environment => 'FAT4'},
#            {:suite => '[F] REGRESSION TESTS 3', :environment => 'FAT4'},
#            {:suite => '[F] REGRESSION TESTS 4', :environment => 'FAT4'},
#            {:suite => '[F] REGRESSION TESTS 5', :environment => 'FAT4'},
#            {:suite => '[F] REGRESSION TESTS 6', :environment => 'FAT4'},
#            {:suite => '[F] REGRESSION TESTS 7', :environment => 'FAT4'},
#	     {:suite => '[F] REGRESSION TESTS 8', :environment => 'FAT4'},
#            {:suite => '[F] WEB SERVICE TESTS', :environment => 'FAT4'},
#        ]
#}

PROMETERA_REGRESSION_TESTS_JOB = {
    :cron => '30 1 * * *',
    :suites_environments =>
        [
            {:suite => '[P] REGRESSION TESTS El', :environment => 'DEV8PROM'},
            {:suite => '[P] REGRESSION TESTS DH/DC', :environment => 'DEV8PROM'},
            {:suite => '[P] REGRESSION TESTS Gas', :environment => 'DEV8PROM'},
        ]
}

PROMETERA_BRANCH_TESTS_JOB = {
    :cron => '30 2 * * *',
    :suites_environments =>
        [
            {:suite => '[P] REGRESSION TESTS El', :environment => 'DEV9'},
            {:suite => '[P] REGRESSION TESTS DH/DC', :environment => 'DEV9'},
            {:suite => '[P] REGRESSION TESTS Gas', :environment => 'DEV9'},
        ]
}

SKAGERAK_TRUNK_REGRESSION_TESTS_JOB = {
    :cron => '30 4 * * *',
    :suites_environments =>
        [
            {:suite => '[S] REGRESSION SET [daily]', :environment => 'DEV2SKA'},
            {:suite => '[S] REGRESSION SET 1 [roll out]', :environment => 'DEV2SKA'},
            {:suite => '[S] REGRESSION SET 2 [roll out]', :environment => 'DEV2SKA'},
            {:suite => '[S] REGRESSION SET [daily_duringRollOut]', :environment => 'DEV2SKA'},
            {:suite => '[RM] WMS INTEGRATION', :environment => 'DEV2SKA'},
        ]
}

SKAGERAK_BRANCH_REGRESSION_TESTS_JOB = {
    :cron => '30 5 * * *',
    :suites_environments =>
        [
            {:suite => '[S] REGRESSION SET [daily]', :environment => 'DEV3SKA'},
            {:suite => '[S] REGRESSION SET 1 [roll out]', :environment => 'DEV3SKA'},
            {:suite => '[S] REGRESSION SET 2 [roll out]', :environment => 'DEV3SKA'},
            {:suite => '[S] REGRESSION SET [daily_duringRollOut]', :environment => 'DEV3SKA'},
            {:suite => '[RM] WMS INTEGRATION', :environment => 'DEV3SKA'},
        ]
}

FORTUM_PERFORMANCE_TESTS_JOB = {
    :cron => '*/10 22 * * *',
    :suites_environments =>
        [
            {:suite => '[F] PERFORMANCE TESTS', :environment => 'FAT'},
        ]
}

FORTUM_LOAD_TESTS_JOB = {
    :cron => '0 2 * * *',
    :suites_environments =>
        [
            {:suite => '[F] LOAD TESTS', :environment => 'FAT'},
        ]
}

AM_TRUNK_REGRESSION_TESTS_JOB = {
    :cron => '0 2 * * *',
    :suites_environments =>
        [
            {:suite => '[AM] REGRESSION TESTS 1', :environment => 'DEV8PROM'},
        ]
}

AM_BRANCH_REGRESSION_TESTS_JOB = {
    :cron => '0 2 * * *',
    :suites_environments =>
        [
            {:suite => '[AM] REGRESSION TESTS 1', :environment => 'DEV9'},
        ]
}

# everything below this should be the same for both production and development

TEST_SUITES = [
    {:name => '[F] SMOKE TESTS', :type => 'Suite', :environments => ['FAT', 'FAT4', 'FAT5', 'FAT12'], :piazza => true, :default_number_of_tests => 2, :priority => 1, :project_file => 'Fortum_regression_krenevla.xml'},
    {:name => '[F] WEB SERVICE TESTS', :type => 'Suite', :environments => ['FAT', 'FAT4', 'FAT5', 'FAT12'], :piazza => true, :default_number_of_tests => 5, :priority => 2, :project_file => 'Fortum_regression_krenevla.xml'},
    {:name => '[F] REGRESSION TESTS 1', :type => 'Suite', :environments => ['FAT', 'FAT4', 'FAT5', 'FAT12'], :piazza => true, :default_number_of_tests => 30, :priority => 3, :project_file => 'Fortum_regression_krenevla.xml'},
    {:name => '[F] REGRESSION TESTS 2', :type => 'Suite', :environments => ['FAT', 'FAT4', 'FAT5', 'FAT12'], :piazza => true, :default_number_of_tests => 32, :priority => 4, :project_file => 'Fortum_regression_krenevla.xml'},
    {:name => '[F] REGRESSION TESTS 3', :type => 'Suite', :environments => ['FAT', 'FAT4', 'FAT5', 'FAT12'], :piazza => true, :default_number_of_tests => 22, :priority => 5, :project_file => 'Fortum_regression_krenevla.xml'},
    {:name => '[F] REGRESSION TESTS 4', :type => 'Suite', :environments => ['FAT', 'FAT4', 'FAT5', 'FAT12'], :piazza => true, :default_number_of_tests => 18, :priority => 6, :project_file => 'Fortum_regression_krenevla.xml'},
    {:name => '[F] REGRESSION TESTS 5', :type => 'Suite', :environments => ['FAT', 'FAT4', 'FAT5', 'FAT12'], :piazza => true, :default_number_of_tests => 17, :priority => 7, :project_file => 'Fortum_regression_krenevla.xml'},
    {:name => '[F] REGRESSION TESTS 6', :type => 'Suite', :environments => ['FAT', 'FAT4', 'FAT5', 'FAT12'], :piazza => true, :default_number_of_tests => 24, :priority => 8, :project_file => 'Fortum_regression_krenevla.xml'},
    {:name => '[F] REGRESSION TESTS 7', :type => 'Suite', :environments => ['FAT', 'FAT4', 'FAT5', 'FAT12'], :piazza => true, :default_number_of_tests => 15, :priority => 9, :project_file => 'Fortum_regression_krenevla.xml'},
    {:name => '[F] REGRESSION TESTS 8', :type => 'Suite', :environments => ['FAT', 'FAT4', 'FAT12'], :piazza => true, :default_number_of_tests => 30, :priority => 10, :project_file => 'Fortum_regression_krenevla.xml'},
    {:name => '[F] REGRESSION TESTS 9', :type => 'Suite', :environments => ['FAT'], :piazza => true, :default_number_of_tests => 5, :priority => 11, :project_file => 'Fortum_regression_benkepet.xml'},
    {:name => '[F] BUFFER TESTS', :type => 'Suite', :environments => ['FAT', 'FAT4', 'FAT12'], :piazza => false, :default_number_of_tests => 4, :priority => 99, :project_file => 'Fortum_regression_krenevla.xml', :buffer => true},
    {:name => '[F] LOAD TESTS', :type => 'Suite', :environments => ['FAT'], :piazza => false, :priority => 98, :project_file => 'Fortum_regression_krenevla.xml', :load => true},
    {:name => '[F] MAINTENANCE TESTS', :type => 'Suite', :environments => ['FAT'], :piazza => false, :priority => 97, :project_file => 'Fortum_regression_krenevla.xml'},
    {:name => '[F] PERFORMANCE TESTS', :type => 'Suite', :environments => ['FAT'], :piazza => false, :priority => 96, :project_file => 'Fortum_regression_krenevla.xml', :performance => true},
    {:name => '[P] REGRESSION TESTS El', :type => 'Suite', :environments => ['DEV8PROM', 'DEV9'], :piazza => true, :default_number_of_tests => 20, :priority => 15, :project_file => 'Prometera_regression_tomalmar.xml'},
    {:name => '[P] REGRESSION TESTS DH/DC', :type => 'Suite', :environments => ['DEV8PROM', 'DEV9'], :piazza => true, :default_number_of_tests => 15, :priority => 17, :project_file => 'Prometera_regression_tomalmar.xml'},
    {:name => '[P] REGRESSION TESTS Gas', :type => 'Suite', :environments => ['DEV8PROM', 'DEV9'], :piazza => true, :default_number_of_tests => 3, :priority => 18, :project_file => 'Prometera_regression_tomalmar.xml'},
    {:name => '[H] REGRESSION TESTS 1', :type => 'Suite', :environments => ['DEVHF02'], :piazza => true, :default_number_of_tests => 4, :priority => 25, :project_file => 'Hafslund_regression_krenevla.xml'},
    {:name => '[H] REGRESSION TESTS 2', :type => 'Suite', :environments => ['DEVHF02'], :piazza => true, :default_number_of_tests => 10, :priority => 26, :project_file => 'Hafslund_regression_krenevla.xml'},
    {:name => '[H] BUFFER TESTS', :type => 'Suite', :environments => ['DEVHF02'], :piazza => false, :default_number_of_tests => 2, :priority => 99, :project_file => 'Hafslund_regression_krenevla.xml', :buffer => true},
    {:name => '[S] REGRESSION SET [daily]', :type => 'Suite', :environments => ['DEV2SKA','DEV3SKA'], :piazza => true, :default_number_of_tests => 42, :priority => 27, :project_file => 'Skagerak_daily_plohalen.xml'},
    {:name => '[S] REGRESSION SET 1 [roll out]', :type => 'Suite', :environments => ['DEV2SKA','DEV3SKA'], :piazza => true, :default_number_of_tests => 15, :priority => 28, :project_file => 'Skagerak_rollOut_plohalen.xml'},
    {:name => '[S] REGRESSION SET 2 [roll out]', :type => 'Suite', :environments => ['DEV2SKA','DEV3SKA'], :piazza => true, :default_number_of_tests => 35, :priority => 28, :project_file => 'Skagerak_rollOut_plohalen.xml'},
    {:name => '[AM] REGRESSION TESTS 1', :type => 'Suite', :environments => ['DEV8PROM', 'DEV9'], :piazza => true, :default_number_of_tests => 5, :priority => 28, :project_file => 'AM_regression_chandkan.xml'},
    {:name => '[S] REGRESSION SET [daily_duringRollOut]', :type => 'Suite', :environments => ['DEV2SKA','DEV3SKA'], :piazza => true, :default_number_of_tests => 20, :priority => 29, :project_file => 'Skagerak_daily_duringRollOut_plohalen.xml'},
    {:name => '[RM] WMS INTEGRATION', :type => 'Suite', :environments => ['DEV2SKA','DEV3SKA'], :piazza => true, :default_number_of_tests => 10, :priority => 30, :project_file => 'RM_regression_gawarshr.xml'},
    {:name => '[MOB] REGRESSION TESTS MOBILE', :type => 'Suite', :environments => ['DEV2SKA'], :piazza => true, :default_number_of_tests => 10, :priority => 31, :project_file => 'Skagerak_gui_plohalen.xml'},
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
         '[F] REGRESSION TESTS 8',
         '[F] REGRESSION TESTS 9',
         '[P] REGRESSION TESTS El',
         '[P] REGRESSION TESTS DH/DC',
	 '[P] REGRESSION TESTS Gas',
         '[H] REGRESSION TESTS 1',
         '[H] REGRESSION TESTS 2',
         '[S] REGRESSION SET [daily]',
         '[S] REGRESSION SET 1 [roll out]',
         '[S] REGRESSION SET 2 [roll out]',
         '[S] REGRESSION SET [daily_duringRollOut]',
         '[AM] REGRESSION TESTS 1',
         '[RM] WMS INTEGRATION',
     ]
    },
    {:name => '[F] SMOKE TESTS',
     :suites => ['[F] SMOKE TESTS'
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
    {:name => '[F] REGRESSION TESTS 8',
     :suites => ['[F] REGRESSION TESTS 8'
     ]
    },
    {:name => '[F] REGRESSION TESTS 9',
     :suites => ['[F] REGRESSION TESTS 9'
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
    {:name => '[F] BUFFER TESTS',
     :suites => ['[F] BUFFER TESTS'
     ]
    },
    {:name => '[P] REGRESSION TESTS El',
     :suites => ['[P] REGRESSION TESTS El'
     ]
    },
    {:name => '[P] REGRESSION TESTS DH/DC',
     :suites => ['[P] REGRESSION TESTS DH/DC'
     ]
    },
    {:name => '[P] REGRESSION TESTS Gas',
     :suites => ['[P] REGRESSION TESTS Gas'
     ]
    },
     {:name => '[S] REGRESSION SET [daily]',
      :suites => ['[S] REGRESSION SET [daily]'
      ]
    },
     {:name => '[S] REGRESSION SET 1 [roll out]',
      :suites => ['[S] REGRESSION SET 1 [roll out]'
      ]
    },
     {:name => '[S] REGRESSION SET 2 [roll out]',
      :suites => ['[S] REGRESSION SET 2 [roll out]'
      ]
    },
     {:name => '[S] REGRESSION SET [daily_duringRollOut]',
      :suites => ['[S] REGRESSION SET [daily_duringRollOut]'
      ]
    },
    {:name => '[H] REGRESSION TESTS 1',
     :suites => ['[H] REGRESSION TESTS 1'
     ]
    },
    {:name => '[H] REGRESSION TESTS 2',
     :suites => ['[H] REGRESSION TESTS 2'
     ]
    },
    {:name => '[H] BUFFER TESTS',
     :suites => ['[H] BUFFER TESTS'
     ]
    },
    {:name => '[AM] REGRESSION TESTS 1',
     :suites => ['[AM] REGRESSION TESTS 1'
     ]
    },
       {:name => '[RM] WMS INTEGRATION',
     :suites => ['[RM] WMS INTEGRATION'
     ]
    }, 
       {:name => '[MOB] REGRESSION TESTS MOBILE',
     :suites => ['[MOB] REGRESSION TESTS MOBILE'
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
    ]


PIAZZA_SCREENS = [
    {:screen_number => 1, :environments => ['FAT']},
    {:screen_number => 2, :environments => ['FAT4']},
    {:screen_number => 3, :environments => ['FAT5']},
    {:screen_number => 4, :environments => ['DEV8PROM']},
    {:screen_number => 5, :environments => ['DEVHF02']},
    {:screen_number => 6, :environments => ['DEV2SKA']},
    {:screen_number => 7, :environments => ['DEV9']},
    {:screen_number => 8, :environments => ['DEV3SKA']},
    {:screen_number => 9, :environments => ['DEV7']},
]
 
DELIVERY_SITE_TYPES = [
    {:id => '[F] M1 1C', :name => '[F] M1 1C', :environments => ['FAT', 'FAT4', 'FAT5', 'FAT12'], :test_suite_name => '[F] BUFFER TESTS', :quota => 100},
    {:id => '[F] M1 1C PTB RDR SelfRead Yes', :name => '[F] M1 1C PTB RDR SelfRead Yes', :environments => ['FAT', 'FAT4', 'FAT5', 'FAT12'], :test_suite_name => '[F] BUFFER TESTS', :quota => 100},
    {:id => '[F] M1 1C PTB RDR SelfRead No', :name => '[F] M1 1C PTB RDR SelfRead No', :environments => ['FAT', 'FAT4', 'FAT12'], :test_suite_name => '[F] BUFFER TESTS', :quota => 100},
    {:id => '[F] M1 1C FULL RDR', :name => '[F] M1 1C FULL RDR', :environments => ['FAT', 'FAT4', 'FAT12'], :test_suite_name => '[F] BUFFER TESTS', :quota => 100},
    {:id => '[F] M1 2C', :name => '[F] M1 2C', :environments => ['FAT', 'FAT4', 'FAT5', 'FAT12'], :test_suite_name => '[F] BUFFER TESTS', :quota => 50},
    {:id => '[F] T7 1C', :name => '[F] T7 1C', :environments => ['FAT', 'FAT4', 'FAT5', 'FAT12'], :test_suite_name => '[F] BUFFER TESTS', :quota => 50},
    {:id => '[F] T1 1C MicroProduction', :name => '[F] T1 1C MicroProduction', :environments => ['FAT', 'FAT4', 'FAT5', 'FAT12'], :test_suite_name => '[F] BUFFER TESTS', :quota => 50},
    {:id => '[F] T1 1C', :name => '[F] T1 1C', :environments => ['FAT', 'FAT4', 'FAT5', 'FAT12'], :test_suite_name => '[F] BUFFER TESTS', :quota => 50},
    {:id => '[F] T1 2C', :name => '[F] T1 2C', :environments => ['FAT', 'FAT4', 'FAT5', 'FAT12'], :test_suite_name => '[F] BUFFER TESTS', :quota => 50},
    {:id => '[F] T1 4C', :name => '[F] T1 4C', :environments => ['FAT', 'FAT4', 'FAT5', 'FAT12'], :test_suite_name => '[F] BUFFER TESTS', :quota => 50},
    {:id => '[H] AMS Z31 1c', :name => '[H] AMS Z31 1c', :environments => ['DEVHF02'], :test_suite_name => '[H] BUFFER TESTS', :quota => 1000},
    {:id => '[H] AMS Z31 2c', :name => '[H] AMS Z31 2c', :environments => ['DEVHF02'], :test_suite_name => '[H] BUFFER TESTS', :quota => 500},
    {:id => '[H] AMS Z32 1c', :name => '[H] AMS Z32 1c', :environments => ['DEVHF02'], :test_suite_name => '[H] BUFFER TESTS', :quota => 500},
]

ENVIRONMENTS = [
    {:name => 'FAT5', :wms_version => '4.9.1'},
    {:name => 'FAT4', :wms_version => '5.0.0'},
    {:name => 'DEV9', :wms_version => '5.0.0'},
    {:name => 'DEV3SKA', :wms_version => '5.0.0'},
    {:name => 'FAT', :wms_version => 'trunk'},
    {:name => 'DEV8PROM', :wms_version => 'trunk'},
    {:name => 'PROM_PERF', :wms_version => 'trunk'},
    {:name => 'DEV2SKA', :wms_version => 'trunk'},
    {:name => 'DEV7', :wms_version => 'trunk'},
    {:name => 'DEVHF02', :wms_version => 'trunk'},
    {:name => 'FAT12', :wms_version => '5.0.xFAT12'},
]
