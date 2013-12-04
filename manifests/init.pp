# == Class: nsr
#
# init.pp for nsr puppet module
#
# Author : Hugo van Duijn
#
class nsr (
  $backup              = false,
  $backuphour          = 1,
  $backupminute        = 1,
  $autorestore         = true,
  $version             = 'latest',
  $backupdir           = '/tmp/backups',
  $restore_directory   = '/tmp/restore',
  $bucket              = 'linuxbackups',
  $bucketfolder        = 'nsr',
  $dest_id             = undef,
  $dest_key            = undef,
  $cloud               = 's3',
  $pubkey_id           = undef,
  $full_if_older_than  = 30,
  $remove_older_than   = 31,
  $coderepo            = 'svn://dev2.etibioinformatics.nl/linnaeus_ng/trunk',
  $repotype            = 'svn',
  $coderoot            = '/var/www/nsr',
  $webdirs             = ['/var/www/nsr',
                          '/var/www/nsr/www',
                          '/var/www/nsr/www/admin',
                          '/var/www/nsr/www/admin/templates',
                          '/var/www/nsr/www/app',
                          '/var/www/nsr/www/app/style',
                          '/var/www/nsr/www/app/templates',
                          '/var/www/nsr/www/shared',
                          '/var/www/nsr/www/shared/media'],
  $rwwebdirs           = ['/var/www/nsr/www/app/templates/templates_c',
                          '/var/www/nsr/www/app/templates/cache',
                          '/var/www/nsr/www/app/style/custom',
                          '/var/www/nsr/www/shared/cache',
                          '/var/www/nsr/www/shared/media/project',
                          '/var/www/nsr/log/',
                          '/var/www/nsr/www/admin/templates/templates_c',
                          '/var/www/nsr/www/admin/templates/cache'],
  $apachegroup         = 'www-data',
  $userDbHost          = 'localhost',
  $userDbUser          = 'linnaeus_user',
  $userDbPassword      = undef,
  $userDbName          = 'nsr',
  $userDbPrefix        = 'lng_nsr_',
  $userDbCharset       = 'utf8',
  $adminDbHost         = 'localhost',
  $adminDbUser         = 'linnaeus_user',
  $adminDbPassword     = undef,
  $adminDbName         = 'nsr',
  $adminDbPrefix       = 'lng_nsr_',
  $adminDbCharset      = 'utf8',

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
    group	=> $apachegroup,
    require 	=> File[$webdirs],
  }

  if ($backup == true) or ($autorestore == true) {
    class { 'mysql::backup':
      backupuser     => 'backupuser',
      backuppassword => 'backuppwd',
      backupdir      => $backupdir,
    }
  }

  if $backup == true {
    class { 'nsr::backup':
      backuphour         => $backuphour,
      backupminute       => $backupminute,
      backupdir          => $backupdir,
      bucket             => $bucket,
      folder             => $bucketfolder,
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
      folder      => $bucketfolder,
      dest_id     => $dest_id,
      dest_key    => $dest_key,
      cloud       => $cloud,
      pubkey_id   => $pubkey_id,
    }
  }

  file { "${coderoot}/configuration/admin/configuration.php":
    content       => template('nsr/adminconfig.erb'),
    mode          => '0640',
    owner         => root,
    group         => $apachegroup,
    require       => Vcsrepo[$coderoot],
  }

  file { "${coderoot}/configuration/app/configuration.php":
    content       => template('nsr/appconfig.erb'),
    mode          => '0640',
    owner         => root,
    group         => $apachegroup,
    require       => Vcsrepo[$coderoot],
  }
}
