Mail.defaults do
  delivery_method :smtp, :address => 'localhost',
  :port => 1025
end

DATA_SOURCE = 'mysql://wmsuser:SalvatorDali01@localhost/wmstools'
PORT = 80
PERFORMANCE_TEST_RESULTS_PER_PAGE = 30

TITANIUM_TRUNK_REGRESSION_TESTS_JOB = {
  :cron => '30 4 * * *',
  :suites_environments =>
  [
  {:suite => '[TIT] REGRESSION TESTS 1', :environment => 'TI_AUTO'},
  ]
}

# everything below this should be the same for both production and development

TEST_SUITES = [
  {:name => '[TIT] REGRESSION TESTS 1', :type => 'Suite', :environments => ['TI_AUTO'], :piazza => true, :default_number_of_tests => 10, :priority => 1, :project_file => 'TIT_gui_klepejir.xml'},
]

TEST_PACKAGES = [
  {:name => 'FULL REGRESSION TEST',
  :suites => [
  '[TIT] REGRESSION TESTS 1',
  ]
  },
  {:name => '[TIT] REGRESSION TESTS 1',
  :suites => ['[TIT] REGRESSION TESTS 1'
  ]
  },
]

PERFORMANCE_TESTS = []

PIAZZA_SCREENS = [
  {:screen_number => 1, :environments => ['TI_AUTO']},
]

DELIVERY_SITE_TYPES = []

ENVIRONMENTS = [
  {:name => 'TI_AUTO', :wms_version => 'trunk'},
]
