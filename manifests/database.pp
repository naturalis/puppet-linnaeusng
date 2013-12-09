# == Class: nsr::database
#
# database.pp for nsr puppet module
#
# Author : Hugo van Duijn
#
class nsr::database (
  $backup,
  $backupmysqlhour,
  $backupmysqlminute,
  $restore,
  $backupdir,
  $userDbName,
  $mysqlUser,
  $mysqlPassword,
  $mysqlRootPassword,
  $mysqlBackupUser,
  $mysqlBackupPassword,
) {

  class { 'mysql::bindings':
    php_enable       => true
  }
  class { 'mysql::server':
    root_password    => $mysqlRootPassword
  }

  # create config directory 
  file { "/etc/nsr":
    ensure      => 'directory',
    mode        => '0700',
  }
  file { "/etc/nsr/mysqlRootPassword" :
    ensure  => present,
    mode    => 0640,
    content => $mysqlRootPassword,
  }

  # create mysql backup and restore scripts
  if ($backup == true) or ($restore == true) {
    mysql::db { $userDbName:
      user           => $mysqlUser,
      password       => $mysqlPassword,
      host           => 'localhost',
      grant          => ['ALL'],
    }
    mysql_grant { "${mysqlbackupuser}@localhost/${userDbName}.*":
      ensure         => 'present',
      user           => "${mysqlBackupUser}@localhost",
      options        => ['GRANT'],
      privileges     => ['ALL'],
      table          => '*.*',
    }
    class { 'mysql::server::backup':
      backupuser      => $mysqlBackupUser,
      backuppassword  => $mysqlBackupPassword,
      backupdir       => $backupdir,
      backupdatabases => [$userDbName], 
      backuprotate    => 1,
      time            => [$backupmysqlhour,$backupmysqlminute],
    }
  }
}
