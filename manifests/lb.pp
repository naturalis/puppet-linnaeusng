# Linnaeus Loadbalancer / reverse proxy
#
#
#
#
#
class role_linnaeusng::lb (


# use certificates, place certificates in files folder of puppet manifest. Be aware of the .gitignore so certs don't end up on github!
  Boolean $usecerthash     = true,
  $cert_hash       = { 'STAR_linnaeus_naturalis_nl'    => { 'private' => 'STAR_linnaeus_naturalis_nl.key',
                                                            'cert'    => 'STAR_linnaeus_naturalis_nl.pem',
                                                            'cacert'  => 'STAR_linnaeus_naturalis_nl_cacert.pem' },
                       'STAR_naturalis_nl'             => { 'private' => 'STAR_naturalis_nl.key',
                                                            'cert'    => 'STAR_naturalis_nl.pem',
                                                            'cacert'  => 'STAR_naturalis_nl_cacert.pem' },
                       'www_nederlandsesoorten_nl'     => { 'private' => 'www_nederlandsesoorten_nl.key',
                                                            'cert'    => 'www_nederlandsesoorten_nl.pem',
                                                            'cacert'  => 'comodo_cacert_bundle.pem' },
                       'www_grasshoppersofeurope_com'  => { 'private' => 'www_grasshoppersofeurope_com.key',
                                                            'cert'    => 'www_grasshoppersofeurope_com.pem' },
                       'www_dutchcaribbeanspecies_org' => { 'private' => 'www_dutchcaribbeanspecies_org.key',
                                                            'cert'    => 'www_dutchcaribbeanspecies_org.pem' }
                     },
  Boolean $useletsencrypt       = false,
  $letsencrypt_domains          = ['linnaeustest.naturalis.nl','*.linnaeustest.naturalis.nl'],
  $letsencrypt_email            = 'aut@naturalis.nl',
  $letsencrypt_version          = 'master',
  $letsencrypt_server           = 'https://acme-v02.api.letsencrypt.org/directory',
  $server       = { 'default_server'            => { 'proxy' => 'http://default_server',
                                                    'server_name'  => ['_'],
                                                    'ssl'          => true,
                                                    'ssl_cert'    => '/etc/ssl/certs/STAR_naturalis_nl.pem',
                                                    'ssl_key'     => '/etc/ssl/private/STAR_naturalis_nl.key',
                                                    'location_cfg_append' => { 'rewrite' => '^ http://linnaeus.naturalis.nl permanent'},
                                                   },
                   'various-001_server'         => { 'proxy' => 'http://various-001',
                                                    'server_name'  => ['various-001.linnaeus.naturalis.nl'],
                                                    'ssl'          => true,
                                                    'ssl_redirect' => true,
                                                    'ssl_cert'    => '/etc/ssl/certs/STAR_linnaeus_naturalis_nl.pem',
                                                    'ssl_key'     => '/etc/ssl/private/STAR_linnaeus_naturalis_nl.key',
                                                   },
                   'various-002_server'         => { 'proxy' => 'http://various-002',
                                                    'server_name'  => ['various-002.linnaeus.naturalis.nl'],
                                                    'ssl'          => true,
                                                    'ssl_redirect' => true,
                                                    'ssl_cert'    => '/etc/ssl/certs/STAR_linnaeus_naturalis_nl.pem',
                                                    'ssl_key'     => '/etc/ssl/private/STAR_linnaeus_naturalis_nl.key',
                                                   },
                   'various-003_server'         => { 'proxy' => 'http://various-003',
                                                    'server_name'  => ['various-003.linnaeus.naturalis.nl'],
                                                    'ssl'          => true,
                                                    'ssl_redirect' => true,
                                                    'ssl_cert'    => '/etc/ssl/certs/STAR_linnaeus_naturalis_nl.pem',
                                                    'ssl_key'     => '/etc/ssl/private/STAR_linnaeus_naturalis_nl.key',
                                                   },
                   'various-004_server'         => { 'proxy' => 'http://various-004',
                                                    'server_name'  => ['various-004.linnaeus.naturalis.nl'],
                                                    'ssl'          => true,
                                                    'ssl_redirect' => true,
                                                    'ssl_cert'    => '/etc/ssl/certs/STAR_linnaeus_naturalis_nl.pem',
                                                    'ssl_key'     => '/etc/ssl/private/STAR_linnaeus_naturalis_nl.key',
                                                   },
                   'various-005_server'         => { 'proxy' => 'http://various-005',
                                                    'server_name'  => ['various-005.linnaeus.naturalis.nl'],
                                                    'ssl'          => true,
                                                    'ssl_redirect' => true,
                                                    'ssl_cert'    => '/etc/ssl/certs/STAR_linnaeus_naturalis_nl.pem',
                                                    'ssl_key'     => '/etc/ssl/private/STAR_linnaeus_naturalis_nl.key',
                                                   },
                 },
  $upstream    = { 'various-001'               => { 'members' => ['172.16.1.155'] },
                   'various-002'               => { 'members' => ['172.16.1.157'] },
                   'various-003'               => { 'members' => ['172.16.1.158'] },
                   'various-004'               => { 'members' => ['172.16.1.159'] },
                   'various-005'               => { 'members' => ['172.16.1.160'] },
                   'default_server'            => { 'members' => ['145.136.241.149'] },
                 },

){

# configure SSL 
  if $usecerthash == true {
    create_resources('role_linnaeusng::lbcerts', $cert_hash)
  }

# letsencrypt
  if $useletsencrypt == true {
    class { 'role_linnaeusng::lbssl': }
  }

class { 'nginx':
  names_hash_bucket_size => '512',
  client_max_body_size   => '100M'
}

#  create_resources
  create_resources(nginx::resource::server,$server,{})
#  create_resources(nginx::resource::location,$location,{})
  create_resources(nginx::resource::upstream,$upstream,{})
}
