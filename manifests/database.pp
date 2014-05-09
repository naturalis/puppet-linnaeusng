# == Class: linnaeusng::database
#
# database.pp for linnaeusng puppet module
#
# Author : Hugo van Duijn
#
class linnaeusng::database (
  $userDbName,
  $mysqlUser,
  $mysqlPassword,
  $mysqlRootPassword,
) {

  class { 'mysql::bindings':
    php_enable       => true
  }
  class { 'mysql::server':
    root_password    => $mysqlRootPassword
  }

  mysql::db { $userDbName:
    user           => $mysqlUser,
    password       => $mysqlPassword,
    host           => 'localhost',
    grant          => ['ALL'],
  }

}
