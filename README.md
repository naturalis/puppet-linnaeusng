puppet-linnaeusng
===================

Puppet modules for deployment of Linnaeus_ng software

Parameters
-------------
All parameters are read from hiera or provisioned by The Foreman. Most parameters have sensible defaults, some exeptions: 
- linnaeusng::configuredb: 'true' 
This configures the database, creates users, adjusts permissions for the database users.
- linnaeusng::repoversion
Manages the version of repocheckout, present = default and advised for production environments. latest may be usefull for development environments. 
- linnaeusng::reposshauth
Use SSH authentication for the git repository, if set to true then the contents of repokey must filled with the private key which has access to the repository
- linnaeusng::repokey
Fill with the private key when ssh authentication is needed for the repository



Classes
-------------
- linnaeusng
- linnaeusng::database
- linnaeusng::instances
- linnaeusng::repo

Dependencies
-------------
- naturalis/base
- puppetlabs/vcsrepo
- puppetlabs/apache2

Examples
-------------
Hiera yaml


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
        allow_override: All
        options: '-Indexes FollowSymLinks MultiViews'
    port: 80
    ssl: no
    serveradmin: aut@naturalis.nl
    priority: 10
linnaeusng::mysqlUser: 'linnaeus_user'
linnaeusng::mysqlPassword: 'skgh23876SDFSD2342
linnaeusng::configuredb: true
linnaeusng::repoversion: present
linnaeusng::coderepo: 'git@github.com:naturalis/linnaeus_ng.git',
linnaeusng::repotype: 'git',
linnaeusng::repokey: '-----BEGIN RSA PRIVATE KEY-----xxxxxxxsxxxxxxxx-----END RSA PRIVATE KEY-----',
linnaeusng::reposshauth: true,


```
Puppet code
```
class { linnaeusng: }
```
Result
-------------
Working webserver with mysql, code from github and config files based on templates.


Limitations
-------------
This module has been built on and tested against Puppet 3 and higher.


The module has been tested on:
- Ubuntu 12.04LTS
- Ubuntu 14.04LTS

Authors
-------------
Author Name <hugo.vanduijn@naturalis.nl>

