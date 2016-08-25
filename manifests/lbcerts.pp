# Linnaeus Loadbalancer / certificates creation
#
#
#
#
#
define linnaeusng::lbcerts (
  $private,
  $cert,
  $cacert          = undef,
  $private_keyname = "/etc/ssl/private/${private}",
  $cert_keyname    = "/etc/ssl/certs/${cert}",
  $cacert_keyname  = "/etc/ssl/certs/${cacert}",
){

# configure SSL 

  file { $private_keyname :
    ensure  => present,
    source  => "puppet:///modules/linnaeusng/${private}",
    mode    => '0600',
  }

  file { $cert_keyname :
    ensure  => present,
    source  => "puppet:///modules/linnaeusng/${cert}",
    mode    => '0600',
  }

  if $cacert {
    file { $cacert_keyname :
      ensure  => present,
      source  => "puppet:///modules/linnaeusng/${cacert}",
      mode    => '0600',
    }
  }
  
}