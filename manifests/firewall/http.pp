# Manages the fireall rules for nginx http access
class nginx::firewall::http {
    firewall { '100 allow http':
        dport  => 80,
        proto  => tcp,
        action => accept,
    }
}
