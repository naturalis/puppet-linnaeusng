puppet-linnaeusng
===================

Puppet modules for deployment of Linnaeus_ng software

Parameters
-------------
All parameters are read from hiera or provisioned by The Foreman.

Classes
-------------
- linnaeusng
- linnaeusng::database
- linnaeusng::instances
- linnaeusng::restore
- linnaeusng::backup


Dependencies
-------------
- naturalis/base
- puppetlabs/vcsrepo
- puppetlabs/apache2
- Jimdo/puppet-duplicity

Examples
-------------
Hiera yaml
dest_id and dest_key are API keys for amazon s3 account


```
linnaeusng:
  www.linnaeusng.nl:
    serveraliases: 'linnaeusng.nl'
    aliases:
      - alias: '/linnaeus_ng'
        path: '/var/www/linnaeusng/www'
    docroot: /var/www/linnaeusng
    directories:
      - path: '/var/www/linnaeusng'
        options: '-Indexes FollowSymLinks MultiViews'
    port: 80
    ssl: no
    serveradmin: aut@naturalis.nl
    priority: 10
linnaeusng::backup: true
linnaeusng::backuphour: 5
linnaeusng::backupminute: 5
linnaeusng::backupdir: '/tmp/backups'
linnaeusng::dest_id: 'provider_id'
linnaeusng::dest_key: 'provider_key'
linnaeusng::restore: true
linnaeusng::bucket: 'linuxbackups'
linnaeusng::bucketfolder: 'linnaeusng'
linnaeusng::mysqlUser: 'linnaeus_user'
linnaeusng::mysqlPassword: 'skgh23876SDFSD2342
linnaeusng::configuredb: true

```
Puppet code
```
class { linnaeusng: }
```
Result
-------------
Working webserver with mysql, restored from duplicity, code from subversion and config files based on templates. with daily duplicity backup.

Limitations
-------------
This module has been built on and tested against Puppet 3 and higher.
mysql_grant will be reapplied every puppet run, this can be disabled by setting the variable : configuredb to false. After setting the variable to false the database class for creation and configuring will not be included anymore. 

The module has been tested on:
- Ubuntu 12.04LTS


Authors
-------------
Author Name <hugo.vanduijn@naturalis.nl>

