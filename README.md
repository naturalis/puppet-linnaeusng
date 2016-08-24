puppet-linnaeusng
===================

Puppet modules for deployment of Linnaeus_ng software and seperate class for loadbalancer with configuration tuned for linnaeus. 

General remarks
-------------
Advised memory specification of server is atleast 2GB.

Parameters
-------------
All parameters are read from hiera or provisioned by The Foreman. Most parameters have sensible defaults, some exeptions: 
- linnaeusng::configuredb: 'true' 
This configures the database, creates users, adjusts permissions for the database users.
- linnaeusng::managerepo
Manages the repocheckout, set to false by default. 
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
- linnaeusng::lb
- linnaeusng::lbcerts


Dependencies
-------------
- naturalis/base 1.0.0
- naturalis/puppet-php 1.0.0 ( forked from thias/puppet-php )
- puppetlabs/puppet-vcsrepo 1.3.1
- puppetlabs/puppet-apache 1.6.0
- puppetlabs/puppet-concat 1.2.4
- puppetlabs/puppet-mysql 3.6.1


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
        options: '-Indexes +FollowSymLinks +MultiViews'
    port: 80
    ssl: no
    serveradmin: aut@naturalis.nl
    priority: 10
linnaeusng::mysqlUser: 'linnaeus_user'
linnaeusng::mysqlPassword: 'skgh23876SDFSD2342
linnaeusng::configuredb: true
linnaeusng::managerepo: true
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
Working webserver with mysql, code from github and config files based on templates. zoneinfo data is also inserted into mysql once and everytime /usr/share/zonedata changes. 


Limitations
-------------
This module has been built on and tested against Puppet 3 and higher.


The module has been tested on:
- Ubuntu 12.04LTS
- Ubuntu 14.04LTS

Authors
-------------
Author Name <hugo.vanduijn@naturalis.nl>

