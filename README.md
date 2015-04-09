WMSTools - Universal Test Runner FrontEnd
=========================================



Running
-------
ruby ./start.rb

Installation
------------

Under Debian Linux write:
sudo apt-get install sqlite3 libsqlite3-dev ruby ruby-dev g++ subversion sudo curl make pkill mysql-server mysql-client libmysqlclient-dev libmysqlclient-dev libssl-dev screen
sudo bundle install

mysql -u root -p
mysql> create database wmstools;
mysql> create database wmstools_staging;
mysql> grant usage on *.* to wmsuser@localhost identified by 'SalvatorDali01';
mysql> grant all privileges on wmstools.* to wmsuser@localhost;
mysql> grant all privileges on wmstools_staging.* to wmsuser@localhost;

Svn password must be stored under user which runs start.rb

JRuby
==============
# Download JRuby tar.gz from http://www.jruby.org/download
# Move downloaded file to your home
tar -xzf jruby-bin-1.7.13.tar.gz
rm jruby-bin-1.7.13.tar.gz
nano -w ~/.profile
-- add this line
---
export PATH="$PATH:$HOME/jruby-1.7.13/bin" # Add jruby to path //dinkotom
---
# make sure java is version 7
java -version
# if not run
sudo update-alternatives --config java
# and choose java 7
# restart the console and try
jruby -v
jruby -S gem install bundler
jruby -S bundle install
jruby start.rb

==================
# copy production database to local database
ssh -l vladan 10.14.140.164 'mysqldump -h localhost -u wmsuser -pSalvatorDali01 wmstools' | mysql -u wmsuser -pSalvatorDali01 wmstools_staging

======================
# starting command
puma --port 8088 --control tcp://0.0.0.0:9293 --control-token SalvatorDali01 config.ru

# restart by
http://localhost:9293/restart?token=SalvatorDali01


Deployed on Thu Mar 26 07:12:57 CET 2015
