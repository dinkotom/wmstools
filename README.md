# WMSTools - Universal Test Runner FrontEnd

WMSTools has been developed as a home-brewed test runner for complex SOAP-UI flow tests but generally it is capable of running many kind of automated tests.

The system consists of a server and a number of agents. The server exposes a GUI to users who are able to run their tests, watch the results and do more interesting things.
It also schedules tests that are supposed to run on regular basis. Users are notified about their test results by email.

The agents do the actual work. Agents can be installed on multiple Linux machines and therefore increase the capacity of the system, i.e. number of test executions running simultaneously.
Each agent watches the test execution queue and when there is a test execution pending in the queue and there is a free capacity on the agent, it executes the test execution and writes the results of the test.
The results are written throughout the test execution and running results can be watched even before the execution finishes.

The server and agents are integrated through a database.

Currently MySQL is used but it is possible to use any kind of relational database.

## Installation
While Server, Agent(s) and the DB can all run on one machine, we recommend to run Server and Agent on different machines. The database can be placed on the same machine as the Server.
Only Linux is currently supported as operating system for both Server and Agents.
While any Linux distribution can be used, the following is applicable for Debian Linux.

### Server and Agents
`sudo apt-get install ruby ruby-dev g++ subversion curl make libssl-dev screen`

### Database
`sudo apt-get install mysql-server mysql-client libmysqlclient-dev libmysqlclient-dev`

```
mysql -u root -p
mysql> create database wmstools;
mysql> create database wmstools_staging;
mysql> grant usage on *.* to wmsuser@localhost identified by 'SalvatorDali01';
mysql> grant all privileges on wmstools.* to wmsuser@localhost;
mysql> grant all privileges on wmstools_staging.* to wmsuser@localhost;
```

### For Development
`sudo apt-get install sqlite3 libsqlite3-dev ruby ruby-dev g++ subversion curl make mysql-server mysql-client libmysqlclient-dev libmysqlclient-dev libssl-dev screen`

## Deployment

### Server
After necessary modifications of the `rakefile.rb` run

`rake deploy_production_server`

Server is automatically started after deployment

### Agents
After necessary modifications of the `rakefile.rb` run

`rake deploy_production_agents`

All agents are automatically started after deployment. All running tests are rolled back and set to pending so that they are executed again after restart of agent.