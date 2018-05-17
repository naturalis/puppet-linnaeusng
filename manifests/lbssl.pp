# == Class: role_lamp::ssl
#
# ssl code for enabline ssl with or without letsencrypt
#
# Author Name <hugo.vanduijn@naturalis.nl>
#
#
define role_linnaeusng::lbssl (
  $letsencrypt_domains,
)
{

# install letsencrypt certs only and crontab
  letsencrypt::certonly { $title:
    domains                 => $letsencrypt_domains,
    manage_cron             => true,
    webservice              => 'nginx',
    plugin                  => 'standalone',
    cron_before_command     => 'service nginx stop',
    cron_success_command    => 'service nginx start',
    require                 => Class['::letsencrypt']
  }

}

