# Linnaeus Loadbalancer / certificates creation
#
#
#
#
#
define linnaeusng::lbcerts (
  $private,
  $cert,
  $cacert,
  $private_keyname = "/etc/ssl/private/${title}_key",
  $cert_keyname    = "/etc/ssl/certs/${title}_pem",
  $cacert_keyname  = "/etc/ssl/certs/${title}_cacert.pem",
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

  file { $cacert_keyname :
    ensure  => present,
    source  => "puppet:///modules/linnaeusng/${cacert}",
    mode    => '0600',
  }
}