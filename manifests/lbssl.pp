# == Class: role_lamp::ssl
#
# ssl code for enabline ssl with or without letsencrypt
#
# Author Name <hugo.vanduijn@naturalis.nl>
#
#
class role_linnaeusng::lbssl (
)
{

# install letsencrypt certs only and crontab
  class { ::letsencrypt:
    repo           => 'https://github.com/certbot/certbot.git',
    install_method => 'vcs',
    version        => 'master',
    config         => {
      email  => $role_linnaeusng::lb::letsencrypt_email,
      server => $role_linnaeusng::lb::letsencrypt_server,
    }
  }
  letsencrypt::certonly { 'letsencrypt_cert':
    domains                 => $role_linnaeusng::lb::letsencrypt_domains,
    manage_cron             => true,
    plugin                  => 'standalone',
    cron_before_command     => 'service nginx stop',
    cron_success_command    => 'service nginx start',
  }

}

