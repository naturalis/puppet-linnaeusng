# == Class: linnaeusng::repo
#
# === Authors
#
# Author Name <hugo.vanduijn@naturalis.nl>
#
#
class linnaeusng::repo (
){

# define variable for template
  $_repokeyname = $linnaeusng::repokeyname

# ensure git package for repo checkouts
  package { 'git':
    ensure => installed,
  }

  if ( $linnaeusng::managerepo == true ) {
  if ( $linnaeusng::reposshauth == false ) {
    vcsrepo { $linnaeusng::coderoot:
      ensure    => $linnaeusng::repoversion,
      provider  => $linnaeusng::repotype,
      source    => $linnaeusng::coderepo,
      revision  => 'master',
      require   => Package['git']
    }
  } else {
    file { '/root/.ssh':
      ensure    => directory,
    }->
    file { "/root/.ssh/${linnaeusng::repokeyname}":
      ensure    => 'present',
      content   => $linnaeusng::repokey,
      mode      => '0600',
    }->
    file { '/root/.ssh/config':
      ensure    => 'present',
      content   =>  template('linnaeusng/sshconfig.erb'),
      mode      => '0600',
    }->
    file{ '/usr/local/sbin/known_hosts.sh' :
      ensure    => 'present',
      mode      => '0700',
      source    => 'puppet:///modules/linnaeusng/known_hosts.sh',
    }->
    exec{ 'add_known_hosts' :
      command   => '/usr/local/sbin/known_hosts.sh',
      path      => '/sbin:/usr/bin:/usr/local/bin/:/bin/',
      provider  => shell,
      user      => 'root',
      unless    => 'test -f /root/.ssh/known_hosts'
    }->
    file{ '/root/.ssh/known_hosts':
      mode      => '0600',
    }->
    vcsrepo { $linnaeusng::coderoot:
      ensure    => $linnaeusng::repoversion,
      provider  => $linnaeusng::repotype,
      source    => $linnaeusng::coderepo,
      user      => 'root',
      revision  => 'master',
      require   => Package['git']
    }
  }
  }
}