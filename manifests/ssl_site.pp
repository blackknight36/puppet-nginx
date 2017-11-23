# Install a configuration file for SSL sites

define nginx::ssl_site (
    String $site_name = $name,
    String $conf_template = 'nginx/ssl.conf.erb',
    String $document_root = '/usr/share/nginx/html',
    Boolean $use_certbot = false,
    ) {

    # hiera does not allow periods in key names therefore we must substitute
    $_site_name = regsubst($site_name, '\.', '_', 'G')

    file { "/etc/nginx/conf.d/${site_name}.ssl.conf":
        content => template($conf_template),
        owner  => 'nginx',
        group  => 'nginx',
        notify => Service['nginx'],
    }

    if $use_certbot == false {
        file {
            default:
                owner  => 'nginx',
                group  => 'nginx',
                notify => Service['nginx'],
            ;

            "/etc/pki/tls/certs/${site_name}.crt":
                content   => lookup("nginx.ssl_site.${_site_name}.public_key"),
                show_diff => false,
                mode      => '0444',
            ;

            "/etc/pki/tls/private/${site_name}.key":
                content   => lookup("nginx.ssl_site.${_site_name}.private_key"),
                show_diff => false,
                mode      => '0440',
            ;
        }
    }
}
