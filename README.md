puppet-nsr
===================

Puppet modules for deployment of Nederlands Soortenregister 

Parameters
-------------
All parameters are read from hiera

Classes
-------------
- nsr
- nsr::database
- nsr::instances
- nsr::restore
- nsr::backup


Dependencies
-------------
- vcsrepo
- apache2 module from puppetlabs
- Jimdo/puppet-duplicity

Examples
-------------
Hiera yaml
dest_id and dest_key are API keys for amazon s3 account


```
nsr:
  www.nederlandssoortenregister.nl:
    serveraliases: 'nederlandssoortenregister.nl'
    aliases:
      - alias: '/linnaeus_ng'
        path: '/var/www/nsr/www'
    docroot: /var/www/nsr
    directories:
      - path: '/var/www/nsr'
        options: '-Indexes FollowSymLinks MultiViews'
    port: 80
    ssl: no
    serveradmin: aut@naturalis.nl
    priority: 10
nsr::backup: true
nsr::backuphour: 5
nsr::backupminute: 5
nsr::backupdir: '/tmp/backups'
nsr::dest_id: 'provider_id'
nsr::dest_key: 'provider_key'
nsr::restore: true
nsr::bucket: 'linuxbackups'
nsr::bucketfolder: 'nsr'
nsr::mysqlUser: 'linnaeus_user'
nsr::mysqlPassword: 'skgh23876SDFSD2342

```
Puppet code
```
class { nsr: }
```
Result
-------------
Working webserver with mysql, restored from duplicity, code from subversion and config files based on templates. with daily duplicity backup.

Limitations
-------------
This module has been built on and tested against Puppet 3 and higher.

The module has been tested on:
- Ubuntu 12.04LTS


Authors
-------------
Author Name <hugo.vanduijn@naturalis.nl>

