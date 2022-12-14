firewall {
    group {
        address-group Allowed-Mgmt {
            address 192.168.1.1-192.168.1.254
        }
    }
    interface eth0 {
        local {
            name OUTSIDE-LOCAL
        }
    }
    name OUTSIDE-LOCAL {
        default-action reject
        rule 10 {
            action accept
            state {
                established enable
                related enable
            }
        }
        rule 20 {
            action accept
            icmp {
                type-name echo-request
            }
            protocol icmp
            state {
                new enable
            }
        }
        rule 30 {
            action drop
            destination {
                port 22
            }
            protocol tcp
            recent {
                count 4
                time minute
            }
            state {
                new enable
            }
        }
        rule 31 {
            action accept
            destination {
                port 22
            }
            protocol tcp
            source {
                group {
                    address-group Allowed-Mgmt
                }
            }
            state {
                new enable
            }
        }
    }
}
interfaces {
    ethernet eth0 {
        address 192.168.1.40/24
        description OUTSIDE
        hw-id 00:0c:29:58:2a:92
    }
    ethernet eth1 {
        address 10.200.1.1/24
        description INSIDE
        hw-id 00:0c:29:58:2a:9c
    }
    loopback lo {
    }
    tunnel tun0 {
        address 10.0.0.2/30
        encapsulation gre
        remote 192.168.1.30
        source-address 192.168.1.40
    }
}
protocols {
    bgp {
        address-family {
            ipv4-unicast {
                network 0.0.0.0/0 {
                }
                network 10.200.0.0/16 {
                }
                redistribute {
                    static {
                    }
                }
            }
        }
        neighbor 10.0.0.1 {
            address-family {
                ipv4-unicast {
                }
            }
            remote-as 65100
        }
        neighbor 10.200.1.2 {
            address-family {
                ipv4-unicast {
                }
            }
            remote-as internal
        }
        neighbor 10.200.1.3 {
            address-family {
                ipv4-unicast {
                }
            }
            remote-as internal
        }
        system-as 65200
    }
    static {
        route 0.0.0.0/0 {
            next-hop 192.168.1.1 {
            }
        }
    }
}
service {
    ssh {
        port 22
    }
}
system {
    config-management {
        commit-revisions 100
    }
    conntrack {
        modules {
            ftp
            h323
            nfs
            pptp
            sip
            sqlnet
            tftp
        }
    }
    console {
        device ttyS0 {
            speed 115200
        }
    }
    host-name nyc-fw
    login {
        banner {
            post-login ""
        }
        user vyos {
            authentication {
                encrypted-password $6$.Tk/IWGT6leiMNk5$FLFJzL0xpyRX0vdh6.4WjUP2XTUF2CgWFrhGBZYXgZvwc1xAHGljsJCaAOaTLR7kdIcf9uXLqX6yYaXwYSjCt0
                plaintext-password ""
            }
        }
    }
    ntp {
        server time1.vyos.net {
        }
        server time2.vyos.net {
        }
        server time3.vyos.net {
        }
    }
    syslog {
        global {
            facility all {
                level info
            }
            facility protocols {
                level debug
            }
        }
    }
}
vpn {
    ipsec {
        esp-group MyESPGroup {
            proposal 1 {
                encryption aes128
                hash sha1
            }
        }
        ike-group MyIKEGroup {
            proposal 1 {
                dh-group 2
                encryption aes128
                hash sha1
            }
        }
        interface eth0
        site-to-site {
            peer atl-fw {
                authentication {
                    mode pre-shared-secret
                    pre-shared-secret MYSECRETKEY
                    remote-id 192.168.1.30
                }
                default-esp-group MyESPGroup
                ike-group MyIKEGroup
                local-address 192.168.1.40
                remote-address 192.168.1.30
                tunnel 1 {
                    protocol gre
                }
            }
        }
    }
}


// Warning: Do not remove the following line.
// vyos-config-version: "bgp@3:broadcast-relay@1:cluster@1:config-management@1:conntrack@3:conntrack-sync@2:dhcp-relay@2:dhcp-server@6:dhcpv6-server@1:dns-forwarding@3:firewall@8:flow-accounting@1:https@4:ids@1:interfaces@26:ipoe-server@1:ipsec@10:isis@2:l2tp@4:lldp@1:mdns@1:monitoring@1:nat@5:nat66@1:ntp@1:openconnect@2:ospf@1:policy@5:pppoe-server@6:pptp@2:qos@1:quagga@10:rpki@1:salt@1:snmp@2:ssh@2:sstp@4:system@25:vrf@3:vrrp@3:vyos-accel-ppp@2:wanloadbalance@3:webproxy@2"
// Release version: 1.4-rolling-202212070318
