# Parameters:
#
class nsr::restore (
  $version = undef,
  $restore_directory = '/tmp/restore/',
  $bucket = undef,
  $folder = undef,
  $dest_id = undef,
  $dest_key = undef,
  $cloud = undef,
  $pubkey_id = undef,
  $appVersion = undef,
  $mysqlBackupUser = undef,
  $mysqlBackupPassword = undef,
  $userDbName = undef,
)
{
  notify {'Restore enabled':}

  package { 'unzip':
    ensure => present,
  }

  duplicity::restore { 'backup':
    directory      => $restore_directory,
    bucket         => $bucket,
    folder         => $folder,
    dest_id        => $dest_id,
    dest_key       => $dest_key,
    cloud          => $cloud,
    pubkey_id      => $pubkey_id,
    post_command   => '/usr/local/sbin/filerestore.sh && /usr/local/sbin/mysqlrestore.sh',
  }

 file { "/usr/local/sbin/filerestore.sh":
    content => template('nsr/filerestore.sh.erb'),
    mode => '0700',
  }

 file { "/usr/local/sbin/mysqlrestore.sh":
    content => template('nsr/mysqlrestore.sh.erb'),
    mode => '0700',
  }

  # create config directory and check version availability
  file { "/etc/nsr":
    ensure      => 'directory',
    mode        => '0700',
  }

  file { "/etc/nsr/${appVersion}" :
    ensure  => present,
    mode    => 0640,
    content => "Version file, created by puppet for nsr restore jobs",
    require => Exec['duplicityrestore.sh'],
  }

  exec { 'duplicityrestore.sh':
    command => '/bin/bash /usr/local/sbin/duplicityrestore.sh',
    path => '/usr/local/sbin:/usr/bin:/usr/sbin:/bin',
    require => File['/usr/local/sbin/duplicityrestore.sh','/usr/local/sbin/filerestore.sh','/usr/local/sbin/mysqlrestore.sh'],
    unless => "/usr/bin/test -f /etc/nsr/${appVersion}"
  }

  exec { 'mysqlrestore.sh':
    command => '/bin/bash /usr/local/sbin/mysqlrestore.sh',
    path => '/usr/local/sbin:/usr/bin:/usr/sbin:/bin',
    require => [Exec['duplicityrestore.sh']],
    unless => "/usr/bin/test -f /etc/nsr/${appVersion}"
  }

  exec { 'filerestore.sh':
    command => '/bin/bash /usr/local/sbin/filerestore.sh',
    path => '/usr/local/sbin:/usr/bin:/usr/sbin:/bin',
    require => Exec['duplicityrestore.sh'],
    unless => "/usr/bin/test -f /etc/nsr/${appVersion}"
  }

 

}

