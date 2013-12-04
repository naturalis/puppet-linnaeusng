# == Class: nsr
#
# Full description of class nsr here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if it
#   has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should not be used in preference to class parameters  as of
#   Puppet 2.6.)
#
# === Examples
#
#  class { nsr:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ]
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2013 Your name here, unless otherwise noted.
#
class nsr (
  $backup = false,
  $backuphour = 1,
  $backupminute = 1,
  $autorestore = true,
  $version = 'latest',
  $backupdir = '/tmp/backups',
  $restore_directory = '/tmp/restore',
  $bucket = 'nsr',
  $dest_id = undef,
  $dest_key = undef,
  $cloud = 's3',
  $pubkey_id = undef,
  $full_if_older_than = 30,
  $remove_older_than = 31,
  $coderepo = 'svn://dev2.etibioinformatics.nl/linnaeus_ng/trunk',
  $repotype = 'svn',
  $coderoot = '/var/www/nsr',
  $webdirs = ['/var/www/nsr',
	      '/var/www/nsr/www',
	      '/var/www/nsr/www/admin',
	      '/var/www/nsr/www/admin/templates',
	      '/var/www/nsr/www/app',
	      '/var/www/nsr/www/app/style',
	      '/var/www/nsr/www/app/templates',
	      '/var/www/nsr/www/shared',
	      '/var/www/nsr/www/shared/media'],
  $rwwebdirs = ['/var/www/nsr/www/app/templates/templates_c',
	        '/var/www/nsr/www/app/templates/cache',
	        '/var/www/nsr/www/app/syle/custom',
	        '/var/www/nsr/www/shared/cache',
	        '/var/www/nsr/www/shared/media/project',
	        '/var/www/nsr/log/',
	        '/var/www/nsr/www/admin/templates/templates_c',
	        '/var/www/nsr/www/admin/templates/cache'],
) {

  include concat::setup
  include mysql::php

  class { 'apache':
    default_mods => true,
    mpm_module => 'prefork',
  }

  include apache::mod::php

  # Create all virtual hosts from hiera
  class { 'nsr::instances': }

  # Create mysql server
  include mysql::server

  # Add hostname to /etc/hosts, svn checkout requires a resolvable hostname
  host { 'localhost':
    ip => '127.0.0.1',
    host_aliases => [ $hostname ],
  }

  package { 'subversion':
    ensure => installed,
  }

  vcsrepo { $coderoot:
    ensure   => latest,
    provider => $repotype,
    source   => $coderepo,
    require  => [ Package['subversion'],Host['localhost'] ],
  }

  file { 'backupdir':
    ensure => 'directory',
    path   => $backupdir,
    mode   => '0700',
    owner  => 'root',
    group  => 'root',
  }

  file { $webdirs:
    ensure 	=> 'directory',
    mode   	=> '0755',
    require 	=> Vcsrepo[$coderoot],
  }

  file { $rwwebdirs:
    ensure 	=> 'directory',
    mode   	=> '0770',
    owner	=> root,
    group	=> webusers,
    require 	=> File[$webdirs],
  }

  if ($backup == true) or ($autorestore == true) {
    class { 'mysql::backup':
      backupuser     => 'myuser',
      backuppassword => 'mypassword',
      backupdir      => $backupdir,
    }
  }

  if $backup == true {
    class { 'nsr::backup':
      backuphour         => $backuphour,
      backupminute       => $backupminute,
      backupdir          => $backupdir,
      bucket             => $bucket,
      dest_id            => $dest_id,
      dest_key           => $dest_key,
      cloud              => $cloud,
      pubkey_id          => $pubkey_id,
      full_if_older_than => $full_if_older_than,
      remove_older_than  => $remove_older_than,
    }
  }

  if $autorestore == true {
    class { 'nsr::restore':
      version     => $restoreversion,
      bucket      => $bucket,
      dest_id     => $dest_id,
      dest_key    => $dest_key,
      cloud       => $cloud,
      pubkey_id   => $pubkey_id,
    }
  }
}

