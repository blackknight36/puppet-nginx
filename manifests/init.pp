# Installs nginx web server

class nginx(
    Boolean $manage_firewall = true,
    Boolean $use_nfs = true
    ) {

    package { [
        'collectd-nginx',
        'nginx',
        ]:
        ensure => installed,
    }

    file { '/etc/collectd.d/nginx.conf':
        source  => 'puppet:///modules/nginx/collectd.d/nginx.conf',
        require => Package['collectd-nginx'],
        notify  => Service['collectd'],
    }

    file { '/usr/share/nginx/html/index.html':
        ensure  => file,
        content => template('nginx/index.html.erb'),
    }

    file { '/etc/nginx/nginx.conf':
        source  => 'puppet:///modules/nginx/nginx.conf',
        require => Package['nginx'],
    } ~>

    service { 'nginx':
        ensure => running,
        enable => true,
    }

    if $manage_firewall == true {
        include 'dart::subsys::firewall::http'
    }

    if $use_nfs == true {
        selinux::boolean { 'httpd_use_nfs':
            value => 'on',
        }
    }

}
