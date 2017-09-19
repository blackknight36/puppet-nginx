# nginx module
#
# Synopsis:
#       Installs and configures nginx.
#
# === Parameters
#
# ==== Optional
#
# [*conf_content*]
#   Literal content for the smb.conf file.  If neither "content" nor
#   "source" is given, the content of the file will be left unmanaged.
#
# [*conf_source*]
#   URI of the smb.conf file content.  If neither "content" nor "source" is
#   given, the content of the file will be left unmanaged.
#
# === Authors
#
#   Michael Watters <michael.watters@dart.biz>

class nginx(
    Boolean $manage_firewall = true,
    Boolean $use_nfs = true,
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

    if $use_nfs == true {
        selboolean { 'httpd_use_nfs':
            value      => 'on',
            persistent => true,
        }
    }

}
