# start mailcatcher before running in development mode
Mail.defaults do
  delivery_method :smtp, :address => 'localhost',
                  :port => 1025
end

set :bind, '0.0.0.0'

DATA_SOURCE = 'mysql://wmsuser:SalvatorDali01@localhost/wmstools_staging'


PORT = 8088
PERFORMANCE_TEST_RESULTS_PER_PAGE = 30

FORTUM_SMOKE_TESTS_JOB = {
    :cron => '30 5 * * *',
    :suites_environments =>
        [
            {:suite => '[F] SMOKE TESTS', :environment => 'FAT'},
        ]
}

# everything below this should be the same for both production and development

TEST_SUITES = [
    {:name => '[F] SMOKE TESTS', :type => 'Suite', :environments => ['FAT'], :piazza => true, :default_number_of_tests => 2, :priority => 1, :project_file => 'Fortum_regression_krenevla.xml'},
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

PIAZZA_SCREENS = [
    {:screen_number => 1, :environments => ['FAT']},
]

DELIVERY_SITE_TYPES = [
    {:id => '[F] M1 1C', :name => '[F] M1 1C', :environments => ['FAT'], :test_suite_name => '[F] BUFFER TESTS', :quota => 2},
]

ENVIRONMENTS = [
    {:name => 'FAT', :wms_version => 'trunk'},

]
