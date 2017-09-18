# Install a configuration file for SSL sites

define nginx::ssl_site (
    String $site_name = $name,
    Boolean $manage_firewall = true,
    String $conf_template = 'nginx/ssl.conf.erb',
    ) {

    if $manage_firewall == true {
        firewall { '100 allow https':
            dport  => 443,
            proto  => tcp,
            action => accept,
        }
    }

    file {
        default:
            ensure => file,
            owner  => 'nginx',
            group  => 'nginx',
            notify => Service['nginx'],
        ;

        "/etc/nginx/conf.d/${site_name}.ssl.conf":
            content => template($conf_template),
        ;

        "/etc/pki/tls/certs/${site_name}.crt":
            content   => lookup('nginx::ssl_site::public_key'),
            show_diff => false,
            mode      => '0444',
        ;

        "/etc/pki/tls/private/${site_name}.key":
            content   => lookup('nginx::ssl_site::private_key'),
            show_diff => false,
            mode      => '0440',
        ;
    }
}
