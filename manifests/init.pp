# == Class: role_linnaeusng
#
# === Authors
#
# Author Name <hugo.vanduijn@naturalis.nl>
#
# === Copyright
#
# Apache2 license 2017.
#
class role_linnaeusng (
  $compose_version              = '1.17.1',
  $repo_source                  = 'https://github.com/naturalis/docker-linnaeusng.git',
  $repo_ensure                  = 'latest',
  $repo_dir                     = '/opt/docker-linnaeusng',
  $mysql_db                     = 'linnaeus_ng',
  $mysql_host                   = 'db',
  $mysql_user                   = 'linnaeus_user',
  $mysql_password               = 'PASSWORD',
  $mysql_root_password          = 'ROOTPASSWORD',
  $mysql_slow_query_log         = '1',
  $mysql_long_query_time        = '1',
  $git_branch                   = 'master',
  $composer_allow_superuser     = '1',
  $table_prefix                 = '',
  $base_path                    = '/data',
  $dev                          = '0',
  $manageenv                    = 'no',
  $logrotate_hash               = { 'apache2'    => { 'log_path' => '/data/linnaeus/apachelog',
                                                      'post_rotate' => "(cd ${repo_dir}; docker-compose exec linnaeus service apache2 reload)",
                                                      'extraline' => 'su root docker'},
                                    'mysql'      => { 'log_path' => '/data/linnaeus/mysqllog',
                                                      'post_rotate' => "(cd ${repo_dir}; docker-compose exec db mysqladmin flush-logs)",
                                                      'extraline' => 'su root docker'},
                                    'linnaeus'   => { 'log_path' => '/data/linnaeus/www/log',
                                                      'rotate' => '183',
                                                      'extraline' => 'su root www-data'},
                                 },
){

  include 'docker'
  include 'stdlib'

  Exec {
    path => '/usr/local/bin/',
    cwd  => $role_linnaeusng::repo_dir,
  }

  file { ['/data','/data/linnaeus','/data/linnaeus/initdb','/data/linnaeus/mysqlconf','/data/linnaeus/apachelog','/data/linnaeus/mysqllog','/opt/traefik'] :
    ensure              => directory,
    owner               => 'root',
    group               => 'docker',
    mode                => '0770',
    require             => Class['docker'],
  }

  file { $role_linnaeusng::repo_dir:
    ensure              => directory,
    mode                => '0770',
  }

  file { '/data/linnaeus/initdb/1_init_db.sql':
    ensure   => file,
    mode     => '0644',
    content  => template('role_linnaeusng/1_init_db.erb'),
    require  => File['/data/linnaeus/initdb'],
  }

  file { '/data/linnaeus/initdb/2_empty_database.sql':
    ensure   => file,
    mode     => '0644',
    source   => 'puppet:///modules/role_linnaeusng/2_empty_database.sql',
    require  => File['/data/linnaeus/initdb'],
  }

  file { '/data/linnaeus/mysqlconf/my-linnaeus.cnf':
    ensure   => file,
    mode     => '0644',
    replace  => $role_linnaeusng::manageenv,
    content  => template('role_linnaeusng/my-linnaeus.cnf.erb'),
    require  => File['/data/linnaeus/mysqlconf'],
  }

  file { '/data/linnaeus/mysqlconf/my-linnaeus-client.cnf':
    ensure   => file,
    mode     => '0600',
    replace  => $role_linnaeusng::manageenv,
    content  => template('role_linnaeusng/my-linnaeus-client.cnf.erb'),
    require  => File['/data/linnaeus/mysqlconf'],
  }

  file { "${role_linnaeusng::repo_dir}/.env":
    ensure   => file,
    mode     => '0600',
    replace  => $role_linnaeusng::manageenv,
    content  => template('role_linnaeusng/env.erb'),
    require  => Vcsrepo[$role_linnaeusng::repo_dir],
    notify   => Exec['Restart containers on change'],
  }

  class {'docker::compose': 
    ensure      => present,
    version     => $role_linnaeusng::compose_version,
    notify      => Exec['apt_update']
  }

  docker_network { 'web':
    ensure   => present,
  }

  ensure_packages(['git','python3'], { ensure => 'present' })
  ensure_packages(['docker-py'],
    { ensure   => 'absent',
         provider => 'pip',
    })

  vcsrepo { $role_linnaeusng::repo_dir:
    ensure    => $role_linnaeusng::repo_ensure,
    source    => $role_linnaeusng::repo_source,
    provider  => 'git',
    user      => 'root',
    revision  => 'master',
    require   => [Package['git'],File[$role_linnaeusng::repo_dir]]
  }

  docker_compose { "${role_linnaeusng::repo_dir}/docker-compose.yml":
    ensure      => present,
    require     => [
      Vcsrepo[$role_linnaeusng::repo_dir],
      File["${role_linnaeusng::repo_dir}/.env"],
      Docker_network['web'],
      File['/data/linnaeus/initdb/2_empty_database.sql'],
      File['/data/linnaeus/initdb/1_init_db.sql'],
      File["${role_linnaeusng::repo_dir}/.env"]
    ]
  }

  exec { 'Pull containers' :
    command  => 'docker-compose pull',
    schedule => 'everyday',
  }

  exec { 'Up the containers to resolve updates' :
    command  => 'docker-compose up -d',
    schedule => 'everyday',
    require  => Exec['Pull containers']
  }

  exec {'Restart containers on change':
    refreshonly => true,
    command     => 'docker-compose up -d',
    require     => Docker_compose["${role_linnaeusng::repo_dir}/docker-compose.yml"]
  }

  # deze gaat per dag 1 keer checken
  # je kan ook een range aan geven, bv tussen 7 en 9 's ochtends
  schedule { 'everyday':
     period  => daily,
     repeat  => 1,
     range => '5-7',
  }

  create_resources('role_linnaeusng::logrotate', $logrotate_hash)

}
