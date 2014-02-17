puppet-linnaeusng
===================

Puppet modules for deployment of Linnaeus_ng software

Parameters
-------------
All parameters are read from hiera or provisioned by The Foreman. Most parameters have sensible defaults, some exeptions: 
- linnaeusng::configuredb: 'true' 
This configures the database, creates users, adjusts permissions for the database users and ensures backup scripts for mysql. The grant keeps reapplying when set to true, it is advisable to set this parameter to false as soon as provisioning is completed. 
- linnaeusng::extra_users_hash
This creates extra users based on the class base::users from naturalis/base. Users will be granted sudo usage rights. Example hash:
```
linnaeusng::extra_users_hash:
  user1:
    comment: "Example user 1"
    shell: "/bin/zsh"
    ssh_key:
      type: "ssh-rsa"
      comment: "user1.soortenregister.nl"
      key: "AAAAB3sdfgsdfgzyc2EAAAABJQAAAIEArnZ3K6vJ8ZisdqPhsdfgsdf5gdKkpuf5rCqOgGphDrBt3ntT7+rWzjx39Im64CCoL+q6ZKgckEZMjGaOKcV+c77nCmSb8eqAM/4eltwj+OgJ5K5DVi1pUaWxR5IoeiulZK36DetVZJCGCkxxLopjSDFGAS234aPC13cLM0Qqfxk="
```


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

