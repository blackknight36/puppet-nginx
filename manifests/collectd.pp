# Install monitoring configuration for nginx/collectd

class nginx::collectd {

  package { 'collectd-nginx':
    ensure => installed,
  }

  file { '/etc/collectd.d/nginx.conf':
    source  => 'puppet:///modules/nginx/collectd.d/nginx.conf',
    require => Package['collectd-nginx'],
    notify  => Service['collectd'],
  }

}
