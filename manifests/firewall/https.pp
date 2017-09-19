# Manages the fireall rules for nginx SSL access

class nginx::firewall::https {
    firewall { '100 allow https':
        dport  => 443,
        proto  => tcp,
        action => accept,
    }
}
