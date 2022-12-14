high-availability {
    vrrp {
        group management {
            address 10.100.150.1/24 {
            }
            hello-source-address 10.100.150.2
            interface eth1.150
            no-preempt
            peer-address 10.100.150.3
            priority 200
            vrid 150
        }
        group nsx-rtep {
            address 10.100.176.1/24 {
            }
            hello-source-address 10.100.176.2
            interface eth1.176
            no-preempt
            peer-address 10.100.176.3
            priority 200
            vrid 176
        }
        group nsx-tep {
            address 10.100.175.1/24 {
            }
            hello-source-address 10.100.175.2
            interface eth1.175
            no-preempt
            peer-address 10.100.175.3
            priority 200
            vrid 175
        }
        group servers {
            address 10.100.161.1/24 {
            }
            hello-source-address 10.100.161.2
            interface eth1.161
            no-preempt
            peer-address 10.100.161.3
            priority 200
            vrid 161
        }
        group vip {
            address 10.100.55.1/24 {
            }
            hello-source-address 10.100.55.2
            interface eth1.55
            no-preempt
            peer-address 10.100.55.3
            priority 200
            vrid 55
        }
    }
}
interfaces {
    ethernet eth0 {
        address 10.100.1.2/24
        description LAN
        hw-id 00:0c:29:cb:65:b9
    }
    ethernet eth1 {
        description DC
        hw-id 00:0c:29:cb:65:c3
        vif 55 {
            address 10.100.55.2/24
            description vip
        }
        vif 150 {
            address 10.100.150.2/24
            description management
        }
        vif 161 {
            address 10.100.161.2/24
            description servers
        }
        vif 173 {
            address 10.100.173.1/24
            description nsx-t0-uplink-1
        }
        vif 175 {
            address 10.100.175.2/24
            description nsx-tep
        }
        vif 176 {
            address 10.100.176.2/24
            description nsx-rtep
        }
    }
    loopback lo {
    }
}
protocols {
    bgp {
        address-family {
            ipv4-unicast {
                redistribute {
                    connected {
                    }
                }
            }
        }
        neighbor 10.100.1.1 {
            address-family {
                ipv4-unicast {
                }
            }
            remote-as internal
        }
        neighbor 10.100.1.3 {
            address-family {
                ipv4-unicast {
                }
            }
            remote-as internal
        }
        system-as 65100
    }
    static {
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
    host-name atl-tor-a
    login {
        banner {
            post-login ""
        }
        user vyos {
            authentication {
                encrypted-password $6$8CBr/rBVZJYZoZ7i$e28osEh4dfGAED1Uvwx/QE1G.kaOdK5CH./LTpOdDYyelwI9F11EqFa/9o.JpdZ/hX..muZnkiaHfb9XiWGDS1
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


// Warning: Do not remove the following line.
// vyos-config-version: "bgp@3:broadcast-relay@1:cluster@1:config-management@1:conntrack@3:conntrack-sync@2:dhcp-relay@2:dhcp-server@6:dhcpv6-server@1:dns-forwarding@3:firewall@8:flow-accounting@1:https@4:ids@1:interfaces@26:ipoe-server@1:ipsec@10:isis@2:l2tp@4:lldp@1:mdns@1:monitoring@1:nat@5:nat66@1:ntp@1:openconnect@2:ospf@1:policy@5:pppoe-server@6:pptp@2:qos@1:quagga@10:rpki@1:salt@1:snmp@2:ssh@2:sstp@4:system@25:vrf@3:vrrp@3:vyos-accel-ppp@2:wanloadbalance@3:webproxy@2"
// Release version: 1.4-rolling-202212070318
