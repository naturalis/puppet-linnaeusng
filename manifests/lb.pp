# Linnaeus Loadbalancer / reverse proxy
#
#
#
#
#
class linnaeusng::lb (
  $vhost       = { 'default_server'            => { 'proxy' => 'http://default_server',
                                                    'server_name' => ['_'],
                                                    'ssl'         => true,
                                                    'ssl_cert'    => '/var/lib/puppet/ssl/certs/linnaeus-lb-001.naturalis.nl.pem',
                                                    'ssl_key'     => '/var/lib/puppet/ssl/private_keys/linnaeus-lb-001.naturalis.nl.pem',
                                                    'location_cfg_append' => { 'rewrite' => '^ http://linnaeus.naturalis.nl permanent'},
                                                   },
                   'orchidsnguinea_vhost'      => { 'proxy' => 'http://orchidsnguinea',
                                                    'server_name' => ['orchidsnguinea.linnaeus.naturalis.nl','orchids.naturalis.nl'],
                                                    'ssl'         => true,
                                                    'ssl_cert'    => '/var/lib/puppet/ssl/certs/linnaeus-lb-001.naturalis.nl.pem',
                                                    'ssl_key'     => '/var/lib/puppet/ssl/private_keys/linnaeus-lb-001.naturalis.nl.pem',
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

  class { 'nginx': }

#  create_resources
  create_resources(nginx::resource::vhost,$vhost,{})
  create_resources(nginx::resource::location,$location,{})
  create_resources(nginx::resource::upstream,$upstream,{})
}
