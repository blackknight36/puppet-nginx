# Install a configuration file for SSL sites

class nginx::ssl_site (
    String $site_name = $::fqdn,
    Boolean $manage_firewall = true,
    String $conf_template = 'nginx/ssl.conf.erb',
    ) {

    File {
        owner  => 'nginx',
        group  => 'nginx',
        notify => Service['nginx'],
    }

    if $manage_firewall == true {
        firewall { '100 allow https':
            dport  => 443,
            proto  => tcp,
            action => accept,
        }
    }

    file { "/etc/nginx/conf.d/${site_name}.ssl.conf":
        content => template($conf_template),
    }

    file { "/etc/pki/tls/certs/${site_name}.crt":
        source => "puppet:///modules/files/private/${site_name}/ssl/${site_name}.crt",
        mode   => '0444',
    }

    file { "/etc/pki/tls/private/${site_name}.key":
        source => "puppet:///modules/files/private/${site_name}/ssl/${site_name}.key",
        mode   => '0440',
    }

}
