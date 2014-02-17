# == Class: linnaeusng
#
# init.pp for linnaeusng puppet module
#
# Author : Hugo van Duijn
#
class linnaeusng (
  $configuredb         = true,
  $backup              = false,
  $backuphour          = 5,
  $backupminute        = 5,
  $backupmysqlhour     = 4,
  $backupmysqlminute   = 4,
  $restore             = false,
  $version             = 'latest',
  $backupdir           = '/tmp/backups',
  $restore_directory   = '/tmp/restore',
  $bucket              = 'linuxbackups',
  $bucketfolder        = 'linnaeusng',
  $extra_users_hash    = undef,
  $dest_id             = undef,
  $dest_key            = undef,
  $cloud               = 's3',
  $pubkey_id           = undef,
  $full_if_older_than  = 30,
  $remove_older_than   = 31,
  $coderepo            = 'svn://dev2.etibioinformatics.nl/linnaeus_ng/trunk',
  $repotype            = 'svn',
  $coderoot            = '/var/www/linnaeusng',
  $webdirs             = ['/var/www/linnaeusng',
                          '/var/www/linnaeusng/www',
                          '/var/www/linnaeusng/www/admin',
                          '/var/www/linnaeusng/www/admin/templates',
                          '/var/www/linnaeusng/www/app',
                          '/var/www/linnaeusng/www/app/style',
                          '/var/www/linnaeusng/www/app/templates',
                          '/var/www/linnaeusng/www/shared',
                          '/var/www/linnaeusng/www/shared/media'],
  $rwwebdirs           = ['/var/www/linnaeusng/www/app/templates/templates_c',
                          '/var/www/linnaeusng/www/app/templates/cache',
                          '/var/www/linnaeusng/www/app/style/custom',
                          '/var/www/linnaeusng/www/shared/cache',
                          '/var/www/linnaeusng/www/shared/media/project',
                          '/var/www/linnaeusng/log/',
                          '/var/www/linnaeusng/www/admin/templates/templates_c',
                          '/var/www/linnaeusng/www/admin/templates/cache'],
  $apachegroup         = 'www-data',
  $userDbHost          = 'localhost',
  $userDbName          = 'linnaeusng',
  $userDbPrefix        = 'lng_linnaeusng_',
  $userDbCharset       = 'utf8',
  $adminDbHost         = 'localhost',
  $adminDbName         = 'linnaeusng',
  $adminDbPrefix       = 'lng_linnaeusng_',
  $adminDbCharset      = 'utf8',
  $mysqlUser           = 'linnaeus_user',
  $mysqlPassword,
  $mysqlRootPassword   = 'defaultrootpassword',
  $mysqlBackupUser     = 'backupuser',
  $mysqlBackupPassword = 'defaultbackuppassword',
  $appVersion          = '1.0.0',
  $instances           = {'linnaeusng.naturalis.nl' => { 
                           'serveraliases'   => '*.naturalis.nl',
                           'aliases'         => [{ 'alias' => '/linnaeus_ng', 'path' => '/var/www/linnaeusng/www' }],
                           'docroot'         => '/var/www/linnaeusng',
                           'directories'     => [{ 'path' => '/var/www/linnaeusng', 'options' => '-Indexes FollowSymLinks MultiViews', 'AllowOverride' => 'none' }],
                           'port'            => 80,
                           'serveradmin'     => 'webmaster@linnaeusng.naturalis.nl',
                           'priority'        => 10,
                          },
                          },
) {

  # include concat and mysql 
  include concat::setup

  if ($configuredb == true) {
    class { 'linnaeusng::database':
      backup              => $backup,
      backupmysqlhour     => $backupmysqlhour,
      backupmysqlminute   => $backupmysqlminute,
      restore             => $restore,
      backupdir           => $backupdir,
      userDbName          => $userDbName,
      mysqlUser           => $mysqlUser,
      mysqlPassword       => $mysqlPassword,
      mysqlRootPassword   => $mysqlRootPassword,
      mysqlBackupUser     => $mysqlBackupUser,
      mysqlBackupPassword => $mysqlBackupPassword,
    }
  }

  # install apache
  class { 'apache':
    default_mods => true,
    mpm_module => 'prefork',
  }
  include apache::mod::php


  # Create all virtual hosts from hiera
  class { 'linnaeusng::instances': 
    instances => $instances,
  }

  # Add hostname to /etc/hosts, svn checkout requires a resolvable hostname
  host { 'localhost':
    ip => '127.0.0.1',
    host_aliases => [ $hostname ],
  }

  # Get data from SVN repo
  package { 'subversion':
    ensure => installed,
  }
  vcsrepo { $coderoot:
    ensure   => latest,
    provider => $repotype,
    source   => $coderepo,
    require  => [ Package['subversion'],Host['localhost'] ],
  }

  # create application specific directories  
  file { $webdirs:
    ensure 	=> 'directory',
    mode   	=> '0755',
    require 	=> Vcsrepo[$coderoot],
  }

  file { $rwwebdirs:
    ensure 	=> 'directory',
    mode   	=> '0660',
    owner	=> root,
    group	=> $apachegroup,
    recurse     => true,
    require 	=> File[$webdirs],
  }

  # create backup job
  if $backup == true {
    class { 'linnaeusng::backup':
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

  # start restore job
  if ($restore == true) {
    class { 'linnaeusng::restore':
      version              => $restoreversion,
      bucket               => $bucket,
      folder               => $bucketfolder,
      dest_id              => $dest_id,
      dest_key             => $dest_key,
      cloud                => $cloud,
      pubkey_id            => $pubkey_id,
      appVersion           => $appVersion,
      mysqlBackupUser      => $mysqlBackupUser,
      mysqlBackupPassword  => $mysqlBackupPassword,
      userDbName           => $userDbName,
    }
  }

  # create extra users
  if $extra_users_hash {
    create_resources('base::users', parseyaml($extra_users_hash))
  }


  # create config files based on templates. 
  file { "${coderoot}/configuration/admin/configuration.php":
    content       => template('linnaeusng/adminconfig.erb'),
    mode          => '0640',
    owner         => root,
    group         => $apachegroup,
    require       => Vcsrepo[$coderoot],
  }

  file { "${coderoot}/configuration/app/configuration.php":
    content       => template('linnaeusng/appconfig.erb'),
    mode          => '0640',
    owner         => root,
    group         => $apachegroup,
    require       => Vcsrepo[$coderoot],
  }
}
