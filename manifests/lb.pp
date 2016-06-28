# Linnaeus Loadbalancer / reverse proxy
#
#
#
#
#
class linnaeusng::lb (
  $private,
  $cert,
  $cacert,
  $private_keyname = '/etc/ssl/private/STAR_linnaeus_naturalis_nl_key',
  $cert_keyname    = '/etc/ssl/certs/STAR_linnaeus_naturalis_nl_pem',
  $cacert_keyname  = '/etc/ssl/certs/STAR_linnaeus_naturalis_nl_cacert.pem',

  $vhost       = { 'default_server'            => { 'proxy' => 'http://default_server',
                                                    'server_name' => ['_'],
                                                    'ssl'         => true,
                                                    'ssl_cert'    => '/etc/ssl/certs/STAR_linnaeus_naturalis_nl_pem',
                                                    'ssl_key'     => '/etc/ssl/private/STAR_linnaeus_naturalis_nl_key',
                                                    'location_cfg_append' => { 'rewrite' => '^ http://linnaeus.naturalis.nl permanent'},
                                                   },
                   'orchidsnguinea_vhost'      => { 'proxy' => 'http://orchidsnguinea',
                                                    'server_name' => ['orchidsnguinea.linnaeus.naturalis.nl','orchids.naturalis.nl'],
                                                    'ssl'         => true,
                                                    'ssl_cert'    => '/etc/ssl/certs/STAR_linnaeus_naturalis_nl_pem',
                                                    'ssl_key'     => '/etc/ssl/private/STAR_linnaeus_naturalis_nl_key',
                                                   }
                 },
  $location    = { 'loc_orchidsnguinea_ssl'    => { 'location' => '/linnaeus_ng/admin/',
                                                    'location_cfg_append' => { 'rewrite' => '^ https://$server_name$request_uri? permanent' },
                                                    'vhost' => 'orchidsnguinea_vhost',
                                                    'proxy' => 'https://orchidsnguinea'},
                 },
  $upstream    = { 'orchidsnguinea'            => { 'members' => ['145.136.240.186'] },
                   'default_server'            => { 'members' => ['145.136.241.149'] },
                 },

){

# configure SSL 

  file { $private_keyname :
    ensure  => present,
    content => $private,
    mode    => '0600',
  }

  file { $cert_keyname :
    ensure  => present,
    content => $cert,
    mode    => '0600',
  }

  file { $cacert_keyname :
    ensure  => present,
    content => $cacert,
    mode    => '0600',
  }


  class { 'nginx':
    require => [File[$private_keyname],File[$cert_keyname],File[$cacert_keyname]],
  }

#  create_resources
  create_resources(nginx::resource::vhost,$vhost,{})
  create_resources(nginx::resource::location,$location,{})
  create_resources(nginx::resource::upstream,$upstream,{})
}
