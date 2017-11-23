# nginx module
#
# Synopsis:
#       Installs and configures nginx.
#
# === Parameters
#
# [*manage_firewall*]
#   Enables automatic management of iptables firewall rules.  Default to true.
#
# [*network_connect*]
#   Configure SE Linux to allow nginx scripts and modules to connect to the
#   network using TCP.  One of: true or false (default).
#
# [*conf_content*]
#   Literal content for the nginx.conf file.  If neither "content" nor
#   "source" is given, the content of the file will be left unmanaged.
#
# [*conf_source*]
#   URI of the nginx.conf file content.  If neither "content" nor "source" is
#   given, the content of the file will be left unmanaged.
#
# [*use_nfs*]
#   Configure SE Linux to allow the serving of content reached via NFS.
#   One of: true or false (default).
#
# === Authors
#
#   Michael Watters <michael.watters@dart.biz>

class nginx (
    Boolean $manage_firewall = true,
    Boolean $use_nfs = false,
    Boolean $network_connect = false,
    Optional[String] $conf_content = undef,
    Optional[String] $conf_source = undef,
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

    file { '/etc/nginx/nginx.conf':
        content => $conf_content,
        source  => $conf_source,
        require => Package['nginx'],
    } ~>

    service { 'nginx':
        ensure => running,
        enable => true,
    }

    if $manage_firewall == true {
        include 'nginx::firewall::http'
    }

    if $facts['selinux'] == true {
        selboolean { 'httpd_can_network_connect':
            persistent => true,
            value      => $network_connect ? {
              true  => 'on',
              false => 'off',
            }
        }

        selboolean { 'httpd_use_nfs':
            persistent => true,
            value      => $use_nfs ? {
              true  => 'on',
              false => 'off',
            }
        }
    }

}
