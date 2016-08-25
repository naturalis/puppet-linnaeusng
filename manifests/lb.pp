# Linnaeus Loadbalancer / reverse proxy
#
#
#
#
#
class linnaeusng::lb (
# use certificates, place certificates in files folder of puppet manifest. Be aware of the .gitignore so certs don't end up on github!
  $usecerthash     = false,
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
  $vhost       = { 'default_server'            => { 'proxy' => 'http://default_server',
                                                    'server_name' => ['_'],
                                                    'ssl'         => true,
                                                    'ssl_cert'    => '/etc/ssl/certs/STAR_linnaeus_naturalis_nl.pem',
                                                    'ssl_key'     => '/etc/ssl/private/STAR_linnaeus_naturalis_nl.key',
                                                    'location_cfg_append' => { 'rewrite' => '^ http://linnaeus.naturalis.nl permanent'},
                                                   },
                   'various-001_vhost'         => { 'proxy' => 'http://various-001',
                                                    'server_name' => ['various-001.linnaeus.naturalis.nl'],
                                                    'ssl'         => true,
                                                    'ssl_cert'    => '/etc/ssl/certs/STAR_linnaeus_naturalis_nl.pem',
                                                    'ssl_key'     => '/etc/ssl/private/STAR_linnaeus_naturalis_nl.key',
                                                   },
                   'various-002_vhost'         => { 'proxy' => 'http://various-002',
                                                    'server_name' => ['various-002.linnaeus.naturalis.nl'],
                                                    'ssl'         => true,
                                                    'ssl_cert'    => '/etc/ssl/certs/STAR_linnaeus_naturalis_nl.pem',
                                                    'ssl_key'     => '/etc/ssl/private/STAR_linnaeus_naturalis_nl.key',
                                                   },
                   'various-003_vhost'         => { 'proxy' => 'http://various-003',
                                                    'server_name' => ['various-003.linnaeus.naturalis.nl','img-classify.linnaeus.naturalis.nl'],
                                                    'ssl'         => true,
                                                    'ssl_cert'    => '/etc/ssl/certs/STAR_linnaeus_naturalis_nl.pem',
                                                    'ssl_key'     => '/etc/ssl/private/STAR_linnaeus_naturalis_nl.key',
                                                   },
                   'various-004_vhost'         => { 'proxy' => 'http://various-004',
                                                    'server_name' => ['various-004.linnaeus.naturalis.nl'],
                                                    'ssl'         => true,
                                                    'ssl_cert'    => '/etc/ssl/certs/STAR_linnaeus_naturalis_nl.pem',
                                                    'ssl_key'     => '/etc/ssl/private/STAR_linnaeus_naturalis_nl.key',
                                                   },
                   'various-005_vhost'         => { 'proxy' => 'http://various-005',
                                                    'server_name' => ['various-005.linnaeus.naturalis.nl'],
                                                    'ssl'         => true,
                                                    'ssl_cert'    => '/etc/ssl/certs/STAR_linnaeus_naturalis_nl.pem',
                                                    'ssl_key'     => '/etc/ssl/private/STAR_linnaeus_naturalis_nl.key',
                                                   },
                   'various-006_vhost'         => { 'proxy' => 'http://various-006',
                                                    'server_name' => ['various-006.linnaeus.naturalis.nl'],
                                                    'ssl'         => true,
                                                    'ssl_cert'    => '/etc/ssl/certs/STAR_linnaeus_naturalis_nl.pem',
                                                    'ssl_key'     => '/etc/ssl/private/STAR_linnaeus_naturalis_nl.key',
                                                   },
                   'various-007_vhost'         => { 'proxy' => 'http://various-007',
                                                    'server_name' => ['various-007.linnaeus.naturalis.nl'],
                                                    'ssl'         => true,
                                                    'ssl_cert'    => '/etc/ssl/certs/STAR_linnaeus_naturalis_nl.pem',
                                                    'ssl_key'     => '/etc/ssl/private/STAR_linnaeus_naturalis_nl.key',
                                                   },
                   'various-008_vhost'         => { 'proxy' => 'http://various-008',
                                                    'server_name' => ['various-008.linnaeus.naturalis.nl'],
                                                    'ssl'         => true,
                                                    'ssl_cert'    => '/etc/ssl/certs/STAR_linnaeus_naturalis_nl.pem',
                                                    'ssl_key'     => '/etc/ssl/private/STAR_linnaeus_naturalis_nl.key',
                                                   },
                   'various-009_vhost'         => { 'proxy' => 'http://various-009',
                                                    'server_name' => ['various-009.linnaeus.naturalis.nl'],
                                                    'ssl'         => true,
                                                    'ssl_cert'    => '/etc/ssl/certs/STAR_linnaeus_naturalis_nl.pem',
                                                    'ssl_key'     => '/etc/ssl/private/STAR_linnaeus_naturalis_nl.key',
                                                   },
                   'various-010_vhost'         => { 'proxy' => 'http://various-010',
                                                    'server_name' => ['various-010.linnaeus.naturalis.nl'],
                                                    'ssl'         => true,
                                                    'ssl_cert'    => '/etc/ssl/certs/STAR_linnaeus_naturalis_nl.pem',
                                                    'ssl_key'     => '/etc/ssl/private/STAR_linnaeus_naturalis_nl.key',
                                                   },
                   'various-011_vhost'         => { 'proxy' => 'http://various-011',
                                                    'server_name' => ['various-011.linnaeus.naturalis.nl'],
                                                    'ssl'         => true,
                                                    'ssl_cert'    => '/etc/ssl/certs/STAR_linnaeus_naturalis_nl.pem',
                                                    'ssl_key'     => '/etc/ssl/private/STAR_linnaeus_naturalis_nl.key',
                                                   },
                   'identify_vhost'            => { 'proxy' => 'http://various-011',
                                                    'server_name' => ['identify.naturalis.nl'],
                                                    'ssl'         => true,
                                                    'ssl_cert'    => '/etc/ssl/certs/STAR_naturalis_nl.pem',
                                                    'ssl_key'     => '/etc/ssl/private/STAR_naturalis_nl.key',
                                                   },
                   'various-012_vhost'         => { 'proxy' => 'http://various-012',
                                                    'server_name' => ['various-012.linnaeus.naturalis.nl','orchidsnguinea.linnaeus.naturalis.nl'],
                                                    'ssl'         => true,
                                                    'ssl_cert'    => '/etc/ssl/certs/STAR_linnaeus_naturalis_nl.pem',
                                                    'ssl_key'     => '/etc/ssl/private/STAR_linnaeus_naturalis_nl.key',
                                                   },
                   'orchidsnguinea_vhost'      => { 'proxy' => 'http://various-012',
                                                    'server_name' => ['orchids.naturalis.nl'],
                                                    'ssl'         => true,
                                                    'ssl_cert'    => '/etc/ssl/certs/STAR_naturalis_nl.pem',
                                                    'ssl_key'     => '/etc/ssl/private/STAR_naturalis_nl.key',
                                                   },
                   'various-013_vhost'         => { 'proxy' => 'http://nsr-frontend',
                                                    'server_name' => ['various-013.linnaeus.naturalis.nl','soortenregister.nl','www.soortenregister.nl'],
                                                    'ssl'         => true,
                                                    'ssl_cert'    => '/etc/ssl/certs/STAR_linnaeus_naturalis_nl.pem',
                                                    'ssl_key'     => '/etc/ssl/private/STAR_linnaeus_naturalis_nl.key',
                                                   },
                   'nederlandsesoorten_vhost'  => { 'proxy' => 'http://nsr-frontend',
                                                    'server_name' => ['www.nederlandsesoorten.nl'],
                                                    'ssl'         => true,
                                                    'ssl_cert'    => '/etc/ssl/certs/www_nederlandsesoorten_nl.pem',
                                                    'ssl_key'     => '/etc/ssl/private/www_nederlandsesoorten_nl.key',
                                                   },
                   'various-014_vhost'         => { 'proxy' => 'http://various-014',
                                                    'server_name' => ['various-014.linnaeus.naturalis.nl'],
                                                    'ssl'         => true,
                                                    'ssl_cert'    => '/etc/ssl/certs/STAR_linnaeus_naturalis_nl.pem',
                                                    'ssl_key'     => '/etc/ssl/private/STAR_linnaeus_naturalis_nl.key',
                                                   },
                   'various-015_vhost'         => { 'proxy' => 'http://various-015',
                                                    'server_name' => ['various-015.linnaeus.naturalis.nl','www.dutchcaribbeanspecies.org','dutchcaribbeanspecies.org'],
                                                    'ssl'         => true,
                                                    'ssl_cert'    => '/etc/ssl/certs/STAR_linnaeus_naturalis_nl.pem',
                                                    'ssl_key'     => '/etc/ssl/private/STAR_linnaeus_naturalis_nl.key',
                                                   },
                 },
  $location    = { 'loc_orchidsnguinea_ssl'    => { 'location' => '/linnaeus_ng/admin/',
                                                    'location_cfg_append' => { 'rewrite' => '^ https://$server_name$request_uri? permanent' },
                                                    'vhost' => 'orchidsnguinea_vhost',
                                                    'proxy' => 'https://various-012'},
                   'loc_various-001_ssl'       => { 'location' => '/linnaeus_ng/admin/',
                                                    'location_cfg_append' => { 'rewrite' => '^ https://$server_name$request_uri? permanent' },
                                                    'vhost' => 'various-001_vhost',
                                                    'proxy' => 'https://various-001'},
                   'loc_various-002_ssl'       => { 'location' => '/linnaeus_ng/admin/',
                                                    'location_cfg_append' => { 'rewrite' => '^ https://$server_name$request_uri? permanent' },
                                                    'vhost' => 'various-002_vhost',
                                                    'proxy' => 'https://various-002'},
                   'loc_various-003_ssl'       => { 'location' => '/linnaeus_ng/admin/',
                                                    'location_cfg_append' => { 'rewrite' => '^ https://$server_name$request_uri? permanent' },
                                                    'vhost' => 'various-003_vhost',
                                                    'proxy' => 'https://various-003'},
                   'loc_various-004_ssl'       => { 'location' => '/linnaeus_ng/admin/',
                                                    'location_cfg_append' => { 'rewrite' => '^ https://$server_name$request_uri? permanent' },
                                                    'vhost' => 'various-004_vhost',
                                                    'proxy' => 'https://various-004'},
                   'loc_various-005_ssl'       => { 'location' => '/linnaeus_ng/admin/',
                                                    'location_cfg_append' => { 'rewrite' => '^ https://$server_name$request_uri? permanent' },
                                                    'vhost' => 'various-005_vhost',
                                                    'proxy' => 'https://various-005'},
                   'loc_various-006_ssl'       => { 'location' => '/linnaeus_ng/admin/',
                                                    'location_cfg_append' => { 'rewrite' => '^ https://$server_name$request_uri? permanent' },
                                                    'vhost' => 'various-006_vhost',
                                                    'proxy' => 'https://various-006'},
                   'loc_various-007_ssl'       => { 'location' => '/linnaeus_ng/admin/',
                                                    'location_cfg_append' => { 'rewrite' => '^ https://$server_name$request_uri? permanent' },
                                                    'vhost' => 'various-007_vhost',
                                                    'proxy' => 'https://various-007'},
                   'loc_various-008_ssl'       => { 'location' => '/linnaeus_ng/admin/',
                                                    'location_cfg_append' => { 'rewrite' => '^ https://$server_name$request_uri? permanent' },
                                                    'vhost' => 'various-008_vhost',
                                                    'proxy' => 'https://various-008'},
                   'loc_various-009_ssl'       => { 'location' => '/linnaeus_ng/admin/',
                                                    'location_cfg_append' => { 'rewrite' => '^ https://$server_name$request_uri? permanent' },
                                                    'vhost' => 'various-009_vhost',
                                                    'proxy' => 'https://various-009'},
                   'loc_various-010_ssl'       => { 'location' => '/linnaeus_ng/admin/',
                                                    'location_cfg_append' => { 'rewrite' => '^ https://$server_name$request_uri? permanent' },
                                                    'vhost' => 'various-010_vhost',
                                                    'proxy' => 'https://various-010'},
                   'loc_various-011_ssl'       => { 'location' => '/linnaeus_ng/admin/',
                                                    'location_cfg_append' => { 'rewrite' => '^ https://$server_name$request_uri? permanent' },
                                                    'vhost' => 'various-011_vhost',
                                                    'proxy' => 'https://various-011'},
                   'loc_identify_ssl'          => { 'location' => '/linnaeus_ng/admin/',
                                                    'location_cfg_append' => { 'rewrite' => '^ https://$server_name$request_uri? permanent' },
                                                    'vhost' => 'identify_vhost',
                                                    'proxy' => 'https://various-011'},
                   'loc_various-012_ssl'       => { 'location' => '/linnaeus_ng/admin/',
                                                    'location_cfg_append' => { 'rewrite' => '^ https://$server_name$request_uri? permanent' },
                                                    'vhost' => 'various-012_vhost',
                                                    'proxy' => 'https://various-012'},
                   'loc_various-013_ssl'       => { 'location' => '/linnaeus_ng/admin/',
                                                    'location_cfg_append' => { 'rewrite' => '^ https://$server_name$request_uri? permanent' },
                                                    'vhost' => 'various-013_vhost',
                                                    'proxy' => 'https://various-013'},
                   'loc_nederlandsesoorten_ssl' => { 'location' => '/linnaeus_ng/admin/',
                                                    'location_cfg_append' => { 'rewrite' => '^ https://$server_name$request_uri? permanent' },
                                                    'vhost' => 'nederlandsesoorten_vhost',
                                                    'proxy' => 'https://various-013'},
                   'loc_various-014_ssl'       => { 'location' => '/linnaeus_ng/admin/',
                                                    'location_cfg_append' => { 'rewrite' => '^ https://$server_name$request_uri? permanent' },
                                                    'vhost' => 'various-014_vhost',
                                                    'proxy' => 'https://various-014'},
                   'loc_various-015_ssl'       => { 'location' => '/linnaeus_ng/admin/',
                                                    'location_cfg_append' => { 'rewrite' => '^ https://$server_name$request_uri? permanent' },
                                                    'vhost' => 'various-015_vhost',
                                                    'proxy' => 'https://various-015'},
                 },
  $upstream    = { 'various-001'               => { 'members' => ['172.16.1.52'] },
                   'various-002'               => { 'members' => ['172.16.1.54'] },
                   'various-003'               => { 'members' => ['172.16.1.55'] },
                   'various-004'               => { 'members' => ['172.16.1.56'] },
                   'various-005'               => { 'members' => ['172.16.1.57'] },
                   'various-006'               => { 'members' => ['172.16.1.58'] },
                   'various-007'               => { 'members' => ['172.16.1.59'] },
                   'various-008'               => { 'members' => ['172.16.1.60'] },
                   'various-009'               => { 'members' => ['172.16.1.61'] },
                   'various-010'               => { 'members' => ['172.16.1.62'] },
                   'various-011'               => { 'members' => ['172.16.1.63'] },
                   'various-012'               => { 'members' => ['172.16.1.64'] },
                   'various-013'               => { 'members' => ['172.16.1.65'] },
                   'various-014'               => { 'members' => ['172.16.1.66'] },
                   'various-015'               => { 'members' => ['172.16.1.67'] },
                   'nsr-frontend'              => { 'members' => ['172.16.1.26'] },
                   'default_server'            => { 'members' => ['145.136.241.149'] },
                 },

){

# configure SSL 

  if $usecerthash == true {
    create_resources('linnaeusng::lbcerts', $cert_hash)
  }


# install nginx
  class { 'nginx':
  }

#  create_resources
  create_resources(nginx::resource::vhost,$vhost,{})
  create_resources(nginx::resource::location,$location,{})
  create_resources(nginx::resource::upstream,$upstream,{})
}
