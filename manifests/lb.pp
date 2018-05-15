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
                                                    'ssl_cert'     => '/etc/ssl/certs/STAR_naturalis_nl.pem',
                                                    'ssl_key'      => '/etc/ssl/private/STAR_naturalis_nl.key',
                                                    'location_cfg_append' => { 'rewrite' => '^ http://linnaeus.naturalis.nl permanent'},
                                                   },
                   'nederlandsesoorten_alt'    => { 'proxy' => 'http://nsr-frontend',
                                                    'server_name'  => ['soortenregister.nl','www.soortenregister.nl','nederlandsesoorten.nl'],
                                                    'ssl'          => true,
                                                    'ssl_cert'     => '/etc/ssl/certs/www_nederlandsesoorten_nl.pem',
                                                    'ssl_key'      => '/etc/ssl/private/www_nederlandsesoorten_nl.key',
                                                    'location_cfg_append' => { 'rewrite' => '^ https://www.nederlandsesoorten.nl$request_uri permanent'},
                                                   },
                   'nederlandsesoorten_vhost'  => { 'proxy' => 'http://nsr-frontend',
                                                    'server_name'  => ['www.nederlandsesoorten.nl'],
                                                    'ssl'          => true,
                                                    'ssl_redirect' => true,
                                                    'ssl_cert'     => '/etc/ssl/certs/www_nederlandsesoorten_nl.pem',
                                                    'ssl_key'      => '/etc/ssl/private/www_nederlandsesoorten_nl.key',
                                                   },
                   'grasshoppers_alt'          => { 'proxy' => 'http://grasshoppers-frontend',
                                                    'server_name'  => ['www.ortheur.org','ortheur.org','grasshoppersofeurope.com'],
                                                    'ssl'          => true,
                                                    'ssl_cert'     => '/etc/ssl/certs/www_grasshoppersofeurope_com.pem',
                                                    'ssl_key'      => '/etc/ssl/private/www_grasshoppersofeurope_com.key',
                                                    'location_cfg_append' => { 'rewrite' => '^ https://www.grasshoppersofeurope.com$request_uri permanent'},
                                                   },
                   'grasshoppers_vhost'        => { 'proxy' => 'http://grasshoppers-frontend',
                                                    'server_name'  => ['www.grasshoppersofeurope.com'],
                                                    'ssl'          => true,
                                                    'ssl_redirect' => true,
                                                    'ssl_cert'     => '/etc/ssl/certs/www_grasshoppersofeurope_com.pem',
                                                    'ssl_key'      => '/etc/ssl/private/www_grasshoppersofeurope_com.key',
                                                   },
                   'dutchcaribbeanspecies_vhost' => { 'proxy' => 'http://dcs-frontend',
                                                    'server_name'  => ['www.dutchcaribbeanspecies.org','dutchcaribbeanspecies.org'],
                                                    'ssl'          => true,
                                                    'ssl_redirect' => true,
                                                    'ssl_cert'     => '/etc/ssl/certs/www_dutchcaribbeanspecies_org.pem',
                                                    'ssl_key'      => '/etc/ssl/private/www_dutchcaribbeanspecies_org.key',
                                                   },
                   'various-001_server'         => { 'proxy' => 'http://various-001',
                                                    'server_name'  => ['various-001.linnaeus.naturalis.nl','aetideidae.linnaeus.naturalis.nl','agromyzidae.linnaeus.naturalis.nl','bats-india.linnaeus.naturalis.nl','bris.linnaeus.naturalis.nl','birds-europe.linnaeus.naturalis.nl','blackflies.linnaeus.naturalis.nl','braconidae.linnaeus.naturalis.nl','butterflies-europe.linnaeus.naturalis.nl','chironomidae-exuviae.linnaeus.naturalis.nl','chironomidae-larvae.linnaeus.naturalis.nl','crabs-japan.linnaeus.naturalis.nl','dagvlinders-europa.linnaeus.naturalis.nl','davalliacea.linnaeus.naturalis.nl','duikgids.linnaeus.naturalis.nl','paddenstoelen.linnaeus.naturalis.nl','decapodos-chile.linnaeus.naturalis.nl','diaspididae.linnaeus.naturalis.nl','eurasian-tortricidae.linnaeus.naturalis.nl','european-limnofauna.linnaeus.naturalis.nl','fish-eggs-and-larvae-from-amw.linnaeus.naturalis.nl','fishes-fnam.linnaeus.naturalis.nl','flora-arborea-chile.linnaeus.naturalis.nl','caesalpinioideae.linnaeus.naturalis.nl','flora-burren.linnaeus.naturalis.nl','fw-oligochaeta.linnaeus.naturalis.nl','dinoflagellates.linnaeus.naturalis.nl','insecten-europa.linnaeus.naturalis.nl','flora-british-isles.linnaeus.naturalis.nl','caribbean-diving.linnaeus.naturalis.nl','mushrooms.linnaeus.naturalis.nl','lemurs.linnaeus.naturalis.nl','libellenlarven.linnaeus.naturalis.nl','ns-anthozoa.linnaeus.naturalis.nl','ns-brachiopoda.linnaeus.naturalis.nl','ns-crustacea.linnaeus.naturalis.nl','ns-echinodermata.linnaeus.naturalis.nl','ns-miscellaneous-worms.linnaeus.naturalis.nl','ns-mollusca.linnaeus.naturalis.nl','ns-nemertina.linnaeus.naturalis.nl','ns-platyhelminthes.linnaeus.naturalis.nl','ns-polychaeta.linnaeus.naturalis.nl','ns-pycnogonida.linnaeus.naturalis.nl','ns-sipuncula.linnaeus.naturalis.nl','ns-tunicata.linnaeus.naturalis.nl','marine-lobsters.linnaeus.naturalis.nl','marine-mammals.linnaeus.naturalis.nl','marine-planarians.linnaeus.naturalis.nl','marine-ostracods.linnaeus.naturalis.nl','mormyridae.linnaeus.naturalis.nl','sea-cucumbers.linnaeus.naturalis.nl','orchids-philippines.linnaeus.naturalis.nl','otoliths-northsea.linnaeus.naturalis.nl','pelagic-molluscs.linnaeus.naturalis.nl','prosea-bamboos.linnaeus.naturalis.nl','prosea-edible-fruits-and-nuts.linnaeus.naturalis.nl','prosea-rattans.linnaeus.naturalis.nl','prosea-timber-trees.linnaeus.naturalis.nl','pteromalus.linnaeus.naturalis.nl','indo-malayan-reef-corals.linnaeus.naturalis.nl','reptielen-en-amfibieen.linnaeus.naturalis.nl','reptiles-and-amphibians.linnaeus.naturalis.nl','sharks.linnaeus.naturalis.nl','sponges-ne-atlantic.linnaeus.naturalis.nl','torymus.linnaeus.naturalis.nl','turbellaria.linnaeus.naturalis.nl','turtles.linnaeus.naturalis.nl','genitalia-preparation.linnaeus.naturalis.nl','useful-plants.linnaeus.naturalis.nl','vogels-europa.linnaeus.naturalis.nl','zoetwatervissen.linnaeus.naturalis.nl','ns-zooplankton.linnaeus.naturalis.nl','sat-zooplankton.linnaeus.naturalis.nl','legacy.linnaeus.naturalis.nl'],
                                                    'ssl'          => true,
                                                    'ssl_redirect' => true,
                                                    'ssl_cert'     => '/etc/ssl/certs/STAR_linnaeus_naturalis_nl.pem',
                                                    'ssl_key'      => '/etc/ssl/private/STAR_linnaeus_naturalis_nl.key',
                                                   },
                   'various-002_server'         => { 'proxy' => 'http://various-002',
                                                    'server_name'  => ['various-002.linnaeus.naturalis.nl'],
                                                    'ssl'          => true,
                                                    'ssl_redirect' => true,
                                                    'ssl_cert'     => '/etc/ssl/certs/STAR_linnaeus_naturalis_nl.pem',
                                                    'ssl_key'      => '/etc/ssl/private/STAR_linnaeus_naturalis_nl.key',
                                                   },
                   'various-003_server'         => { 'proxy' => 'http://various-003',
                                                    'server_name'  => ['various-003.linnaeus.naturalis.nl'],
                                                    'ssl'          => true,
                                                    'ssl_redirect' => true,
                                                    'ssl_cert'     => '/etc/ssl/certs/STAR_linnaeus_naturalis_nl.pem',
                                                    'ssl_key'      => '/etc/ssl/private/STAR_linnaeus_naturalis_nl.key',
                                                   },
                   'various-004_server'         => { 'proxy' => 'http://various-004',
                                                    'server_name'  => ['various-004.linnaeus.naturalis.nl','euphausiids.linnaeus.naturalis.nl'],
                                                    'ssl'          => true,
                                                    'ssl_redirect' => true,
                                                    'ssl_cert'     => '/etc/ssl/certs/STAR_linnaeus_naturalis_nl.pem',
                                                    'ssl_key'      => '/etc/ssl/private/STAR_linnaeus_naturalis_nl.key',
                                                   },
                   'various-005_server'         => { 'proxy' => 'http://various-005',
                                                    'server_name'  => ['various-005.linnaeus.naturalis.nl'],
                                                    'ssl'          => true,
                                                    'ssl_redirect' => true,
                                                    'ssl_cert'     => '/etc/ssl/certs/STAR_linnaeus_naturalis_nl.pem',
                                                    'ssl_key'      => '/etc/ssl/private/STAR_linnaeus_naturalis_nl.key',
                                                   },
                 },
  $upstream    = { 'various-001'               => { 'members' => ['172.16.1.155'] },
                   'various-002'               => { 'members' => ['172.16.1.157'] },
                   'various-003'               => { 'members' => ['172.16.1.158'] },
                   'various-004'               => { 'members' => ['172.16.1.159'] },
                   'various-005'               => { 'members' => ['172.16.1.160'] },
                   'nsr-frontend'              => { 'members' => ['172.16.1.89'] },
                   'dcs-frontend'              => { 'members' => ['172.16.1.128'] },
                   'grasshoppers-frontend'     => { 'members' => ['145.136.243.126'] },
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
