ENVIRONMENT = 'development'
PIAZZA_REFRESH_INTERVAL = 300000 # in milliseconds
CHECK_DELIVERY_SITES_COUNT_EVERY = '5m'
NO_SHOWN_ITEMS = 50 #number of test results to be shown
SVN_BASE_PATH = 'http://192.176.148.85/svnrepo/wms'
JIRA_BASE_PATH = 'http://192.176.148.85:8070/browse/'
JIRA_REST_BASE_PATH = 'http://192.176.148.85:8070/rest/api/latest' # don't put slash at the end
JIRA_USERNAME = 'requeste'
JIRA_PASSWORD = 'Ostrava123456'
FISHEYE_BASE_PATH = 'http://192.176.148.85:8060/browse/WMS-SVN' # don't put slash at the end
SVN_TIME_OUT = 10 #seconds
BUFFER_TEST_MAX_FAILED = 5

VERSIONS = {:wms_489 =>
                {:name => '4.9.x', # FAT,PROMETERA,DEV9PROM,DEV3SKA,DEV7
                 :protection_level => 'Low',
                 :svn_branch => 'trunk',
                 :responsible => 'vladan.krenek@tieto.com',
                 :watchers => [],
                 :max_age => 48
                },
            :wms_490 =>
                {:name => '4.9.0', # FAT5
                 :protection_level => 'High',
                 :svn_branch => 'branch/4.9.0',
                 :responsible => 'vladan.krenek@tieto.com',
                 :watchers => [],
                 :max_age => 48
                },
            :wms_482dev =>
                {:name => '4.8.2DEV', # DEV1
                 :protection_level => 'Low',
                 :svn_branch => 'branch/4.8.2DEV',
                 :responsible => 'vladan.krenek@tieto.com',
                 :watchers => [],
                 :max_age => 48
                },
            :wms_491 =>
                {:name => '4.9.1', # FAT4
                 :protection_level => 'High',
                 :svn_branch => 'branch/4.9.1',
                 :responsible => 'vladan.krenek@tieto.com',
                 :watchers => [],
                 :max_age => 48
                },

}
