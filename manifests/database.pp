# == Class: linnaeusng::database
#
# database.pp for linnaeusng puppet module
#
# Author : Hugo van Duijn
#
class linnaeusng::database ()
{

  class { 'mysql::bindings':
    php_enable       => true
  }

  class { 'mysql::server':
    root_password    => $linnaeusng::mysqlRootPassword
  }

  if ($linnaeusng::configuredb == true) {
    mysql::db { $linnaeusng::userDbName:
      user           => $linnaeusng::mysqlUser,
      password       => $linnaeusng::mysqlPassword,
      host           => 'localhost',
      grant          => ['ALL'],
    }
  }
}
