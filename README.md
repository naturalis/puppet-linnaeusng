puppet-linnaeusng
===================

Puppet modules for deployment of Linnaeus_ng software

Parameters
-------------
All parameters are read from hiera or provisioned by The Foreman. Most parameters have sensible defaults, some exeptions: 
- linnaeusng::configuredb: 'true' 
This configures the database, creates users, adjusts permissions for the database users.
- linnaeusng::extra_users_hash
This creates extra users based on the class base::users from naturalis/base. Users will be granted sudo usage rights. Example hash:
- linnaeusng::repoversion
Manages the version of repocheckout, present = default and advised for production environments. latest may be usefull for development environments. 

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
linnaeusng::repoversion: latest 

```
Puppet code
```
class { linnaeusng: }
```
Result
-------------
Working webserver with mysql, code from subversion and config files based on templates.


Limitations
-------------
This module has been built on and tested against Puppet 3 and higher.


The module has been tested on:
- Ubuntu 12.04LTS


Authors
-------------
Author Name <hugo.vanduijn@naturalis.nl>

