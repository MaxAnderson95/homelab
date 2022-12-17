#T0 BGP config for SR instances at ATL
resource "nsxt_policy_bgp_config" "ATL-BGP-Config" {
  site_path    = data.nsxt_policy_site.ATL.path
  gateway_path = nsxt_policy_tier0_gateway.ST-T0-01.path

  enabled               = true
  inter_sr_ibgp         = true
  multipath_relax       = true
  local_as_num          = local.nsx_as_num
  graceful_restart_mode = local.graceful_restart_mode

  #Stretched-DMZ
  route_aggregation {
    prefix       = "172.23.0.0/19"
    summary_only = true
  }

  #ATL-DMZ
  route_aggregation {
    prefix       = "172.23.32.0/19"
    summary_only = true
  }

  #Stretched-LAN
  route_aggregation {
    prefix       = "172.23.128.0/19"
    summary_only = true
  }

  #ATL-LAN
  route_aggregation {
    prefix       = "172.23.160.0/19"
    summary_only = true
  }

  tag {
    tag = "Managed by Terraform"
  }
}

#ATL TOR (Top of Rack Router) BGP Neighbor A
resource "nsxt_policy_bgp_neighbor" "ATL-TOR-A" {
  display_name          = "ATL-TOR-A"
  neighbor_address      = "10.100.173.1"
  bgp_path              = nsxt_policy_bgp_config.ATL-BGP-Config.path
  graceful_restart_mode = local.graceful_restart_mode
  hold_down_time        = local.bgp_hold_down_time
  keep_alive_time       = local.bgp_keep_alive_time
  remote_as_num         = local.atl_peer_as_num
  source_addresses = [
    nsxt_policy_tier0_gateway_interface.ATL-T0-01-EN1-Uplink-173.ip_addresses.0,
    nsxt_policy_tier0_gateway_interface.ATL-T0-01-EN2-Uplink-173.ip_addresses.0,
  ]

  bfd_config {
    enabled  = true
    interval = local.bfd_interval
    multiple = local.bfd_multiple
  }

  tag {
    tag = "Managed by Terraform"
  }
}

#ATL TOR (Top of Rack Router) BGP Neighbor B
resource "nsxt_policy_bgp_neighbor" "ATL-TOR-B" {
  display_name          = "ATL-TOR-A"
  neighbor_address      = "10.100.174.1"
  bgp_path              = nsxt_policy_bgp_config.ATL-BGP-Config.path
  graceful_restart_mode = local.graceful_restart_mode
  hold_down_time        = local.bgp_hold_down_time
  keep_alive_time       = local.bgp_keep_alive_time
  remote_as_num         = local.atl_peer_as_num
  source_addresses = [
    nsxt_policy_tier0_gateway_interface.ATL-T0-01-EN1-Uplink-174.ip_addresses.0,
    nsxt_policy_tier0_gateway_interface.ATL-T0-01-EN2-Uplink-174.ip_addresses.0,
  ]

  bfd_config {
    enabled  = true
    interval = local.bfd_interval
    multiple = local.bfd_multiple
  }

  tag {
    tag = "Managed by Terraform"
  }
}

#Redistribute learned routes from the ST SR instances to the connected T1
resource "nsxt_policy_gateway_redistribution_config" "ATL" {
  gateway_path = nsxt_policy_tier0_gateway.ST-T0-01.path
  site_path    = data.nsxt_policy_site.ATL.path
  bgp_enabled  = true
  rule {
    name  = "Redistribute T1"
    types = ["TIER1_CONNECTED", "TIER1_SEGMENT", "TIER1_SERVICE_INTERFACE"]
  }
}

#Uplink VLAN 173 for ATL
resource "nsxt_policy_vlan_segment" "ATL-T0-01-Uplink-173" {
  display_name        = "ATL-T0-01-Uplink-173"
  transport_zone_path = data.nsxt_policy_transport_zone.ATL_default_vlan.path
  vlan_ids            = ["173"]

  advanced_config {
    connectivity = "ON"
    hybrid       = false
    local_egress = false
    urpf_mode    = "STRICT"
  }

  tag {
    tag = "Managed by Terraform"
  }
}

#Uplink VLAN 174 for ATL
resource "nsxt_policy_vlan_segment" "ATL-T0-01-Uplink-174" {
  display_name        = "ATL-T0-01-Uplink-174"
  transport_zone_path = data.nsxt_policy_transport_zone.ATL_default_vlan.path
  vlan_ids            = ["174"]

  advanced_config {
    connectivity = "ON"
    hybrid       = false
    local_egress = false
    urpf_mode    = "STRICT"
  }

  tag {
    tag = "Managed by Terraform"
  }
}

#Uplink interface for SR instance on EN1 in ATL on VLAN 173
resource "nsxt_policy_tier0_gateway_interface" "ATL-T0-01-EN1-Uplink-173" {
  display_name   = "ATL-T0-01-EN1-Uplink-173"
  type           = "EXTERNAL"
  site_path      = data.nsxt_policy_site.ATL.path
  gateway_path   = nsxt_policy_tier0_gateway.ST-T0-01.path
  edge_node_path = data.nsxt_policy_edge_node.ATL-EN1.path
  segment_path   = nsxt_policy_vlan_segment.ATL-T0-01-Uplink-173.path
  subnets        = ["10.100.173.10/24"]
  tag {
    tag = "Managed by Terraform"
  }
}

#Uplink interface for SR instance on EN2 in ATL on VLAN 173
resource "nsxt_policy_tier0_gateway_interface" "ATL-T0-01-EN2-Uplink-173" {
  display_name   = "ATL-T0-01-EN2-Uplink-173"
  type           = "EXTERNAL"
  site_path      = data.nsxt_policy_site.ATL.path
  gateway_path   = nsxt_policy_tier0_gateway.ST-T0-01.path
  edge_node_path = data.nsxt_policy_edge_node.ATL-EN2.path
  segment_path   = nsxt_policy_vlan_segment.ATL-T0-01-Uplink-173.path
  subnets        = ["10.100.173.11/24"]
  tag {
    tag = "Managed by Terraform"
  }
}

#Uplink interface for SR instance on EN1 in ATL on VLAN 174
resource "nsxt_policy_tier0_gateway_interface" "ATL-T0-01-EN1-Uplink-174" {
  display_name   = "ATL-T0-01-EN1-Uplink-174"
  type           = "EXTERNAL"
  site_path      = data.nsxt_policy_site.ATL.path
  gateway_path   = nsxt_policy_tier0_gateway.ST-T0-01.path
  edge_node_path = data.nsxt_policy_edge_node.ATL-EN1.path
  segment_path   = nsxt_policy_vlan_segment.ATL-T0-01-Uplink-174.path
  subnets        = ["10.100.174.10/24"]
  tag {
    tag = "Managed by Terraform"
  }
}

#Uplink interface for SR instance on EN2 in ATL on VLAN 174
resource "nsxt_policy_tier0_gateway_interface" "ATL-T0-01-EN2-Uplink-174" {
  display_name   = "ATL-T0-01-EN2-Uplink-174"
  type           = "EXTERNAL"
  site_path      = data.nsxt_policy_site.ATL.path
  gateway_path   = nsxt_policy_tier0_gateway.ST-T0-01.path
  edge_node_path = data.nsxt_policy_edge_node.ATL-EN2.path
  segment_path   = nsxt_policy_vlan_segment.ATL-T0-01-Uplink-174.path
  subnets        = ["10.100.174.11/24"]
  tag {
    tag = "Managed by Terraform"
  }
}
