class nginx($manage_firewall = true, $use_nfs = true) {

    package { 'nginx':
        ensure => installed,
    } ->

    file { '/usr/share/nginx/html/index.html':
        ensure  => file,
        content => template('nginx/index.html.erb'),
    }

    file { '/etc/nginx/nginx.conf':
        ensure => file,
        source => 'puppet:///modules/nginx/nginx.conf',
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
