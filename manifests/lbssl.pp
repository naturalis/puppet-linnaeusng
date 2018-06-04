# == Class: role_lamp::ssl
#
# ssl code for enabline ssl with or without letsencrypt
#
# Author Name <hugo.vanduijn@naturalis.nl>
#
#
define role_linnaeusng::lbssl (
  $letsencrypt_domains,
  $cert_file            = "/etc/letsencrypt/live/${letsencrypt_domains[0]}/cert.pem",
  $cert_name            = $title,
  $cert_renew_days      = '30', # don't set this higher than 30 due to --keep-until-renewal option
  $cert_warning_days    = '14',
  $cert_critical_days   = '7',

)
{

# install letsencrypt certs only and crontab
  letsencrypt::certonly { $title:
    domains                 => $letsencrypt_domains,
    manage_cron             => false,
    webservice              => 'nginx',
    plugin                  => 'standalone',
    cron_before_command     => 'service nginx stop',
    cron_success_command    => 'service nginx start',
    require                 => Class['::letsencrypt']
  }

# create check script from template
  file { "/usr/local/sbin/chkcert_${title}.sh":
    mode    => '0755',
    content => template('role_linnaeusng/checkcert.sh.erb'),
  }


# renew certificat when renewdate is due
  exec { "/bin/echo /opt/puppetlabs/puppet/cache/letsencrypt/renew-${title}.sh":
    cwd     => '/opt/letsencrypt/.venv/bin',
    path    => ['/usr/local/sbin','/usr/local/bin','/usr/sbin','/usr/bin','/sbin','/bin','/snap/bin'],
    onlyif  => "/usr/local/sbin/chkcert_${title}.sh | grep renew 2>/dev/null"
  }

# export check so sensu monitoring can make use of it
  @sensu::check { "Check certificate ${title}":
    command => "/usr/local/sbin/chkcert_${title}.sh sensu",
    tag     => 'central_sensu',
}


}

