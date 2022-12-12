#T0 BGP config for SR instances at ATL
resource "nsxt_policy_bgp_config" "ATL_LAB-T0" {
  site_path    = data.nsxt_policy_site.ATL.path
  gateway_path = nsxt_policy_tier0_gateway.LAB-T0.path

  enabled               = true
  inter_sr_ibgp         = true
  multipath_relax       = true
  local_as_num          = local.local_as_num
  graceful_restart_mode = local.graceful_restart_mode

  #ATL
  route_aggregation {
    prefix       = local.atl_nsx_prefix
    summary_only = true
  }

  #Stretched
  route_aggregation {
    prefix       = local.stretched_nsx_prefix
    summary_only = true
  }

  tag {
    tag = "Managed by Terraform"
  }
}

#ATL TOR (Top of Rack Router) BGP Neighbor A
resource "nsxt_policy_bgp_neighbor" "ATL-TOR-A" {
  display_name          = "ATL-TOR-A"
  neighbor_address      = "10.100.21.1"
  bgp_path              = nsxt_policy_bgp_config.ATL_LAB-T0.path
  graceful_restart_mode = local.graceful_restart_mode
  hold_down_time        = local.bgp_hold_down_time
  keep_alive_time       = local.bgp_keep_alive_time
  remote_as_num         = local.atl_peer_as_num
  source_addresses = [
    nsxt_policy_tier0_gateway_interface.ATL_LAB-T0-EN1-Uplink-21.ip_addresses.0,
    nsxt_policy_tier0_gateway_interface.ATL_LAB-T0-EN2-Uplink-21.ip_addresses.0
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

#ATL TOR (Top of Rack Router) BGP Neighbor A
resource "nsxt_policy_bgp_neighbor" "ATL-TOR-B" {
  display_name          = "ATL-TOR-B"
  neighbor_address      = "10.100.22.1"
  bgp_path              = nsxt_policy_bgp_config.ATL_LAB-T0.path
  graceful_restart_mode = local.graceful_restart_mode
  hold_down_time        = local.bgp_hold_down_time
  keep_alive_time       = local.bgp_keep_alive_time
  remote_as_num         = local.atl_peer_as_num
  source_addresses = [
    nsxt_policy_tier0_gateway_interface.ATL_LAB-T0-EN1-Uplink-22.ip_addresses.0,
    nsxt_policy_tier0_gateway_interface.ATL_LAB-T0-EN2-Uplink-22.ip_addresses.0
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
#Redistribute learned routes from the ATL SR instances to the connected T1
resource "nsxt_policy_gateway_redistribution_config" "ATL" {
  gateway_path = nsxt_policy_tier0_gateway.LAB-T0.path
  site_path    = data.nsxt_policy_site.ATL.path
  bgp_enabled  = true
  rule {
    name  = "Redistribute T1"
    types = ["TIER1_CONNECTED", "TIER1_SEGMENT", "TIER1_SERVICE_INTERFACE"]
  }
}

#Uplink VLAN 21 for ATL
resource "nsxt_policy_vlan_segment" "ATL_LAB-T0-Uplink-21" {
  display_name        = "ATL_LAB-T0-Uplink-21"
  transport_zone_path = data.nsxt_policy_transport_zone.ATL_default_vlan.path
  vlan_ids            = ["21"]

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

#Uplink VLAN 22 for ATL
resource "nsxt_policy_vlan_segment" "ATL_LAB-T0-Uplink-22" {
  display_name        = "ATL_LAB-T0-Uplink-22"
  transport_zone_path = data.nsxt_policy_transport_zone.ATL_default_vlan.path
  vlan_ids            = ["22"]

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

#Uplink interface for SR instance on EN1 in ATL on VLAN 21
resource "nsxt_policy_tier0_gateway_interface" "ATL_LAB-T0-EN1-Uplink-21" {
  display_name   = "ATL_LAB-T0-EN1-Uplink-21"
  type           = "EXTERNAL"
  site_path      = data.nsxt_policy_site.ATL.path
  gateway_path   = nsxt_policy_tier0_gateway.LAB-T0.path
  edge_node_path = data.nsxt_policy_edge_node.ATL-EN1.path
  segment_path   = nsxt_policy_vlan_segment.ATL_LAB-T0-Uplink-21.path
  subnets        = ["10.100.21.2/24"]
  tag {
    tag = "Managed by Terraform"
  }
}

#Uplink interface for SR instance on EN1 in ATL on VLAN 22
resource "nsxt_policy_tier0_gateway_interface" "ATL_LAB-T0-EN1-Uplink-22" {
  display_name   = "ATL_LAB-T0-EN1-Uplink-22"
  type           = "EXTERNAL"
  site_path      = data.nsxt_policy_site.ATL.path
  gateway_path   = nsxt_policy_tier0_gateway.LAB-T0.path
  edge_node_path = data.nsxt_policy_edge_node.ATL-EN1.path
  segment_path   = nsxt_policy_vlan_segment.ATL_LAB-T0-Uplink-22.path
  subnets        = ["10.100.22.2/24"]
  tag {
    tag = "Managed by Terraform"
  }
}

#Uplink interface for SR instance on EN2 in ATL on VLAN 21
resource "nsxt_policy_tier0_gateway_interface" "ATL_LAB-T0-EN2-Uplink-21" {
  display_name   = "ATL_LAB-T0-EN2-Uplink-21"
  type           = "EXTERNAL"
  site_path      = data.nsxt_policy_site.ATL.path
  gateway_path   = nsxt_policy_tier0_gateway.LAB-T0.path
  edge_node_path = data.nsxt_policy_edge_node.ATL-EN2.path
  segment_path   = nsxt_policy_vlan_segment.ATL_LAB-T0-Uplink-21.path
  subnets        = ["10.100.21.3/24"]
  tag {
    tag = "Managed by Terraform"
  }
}

#Uplink interface for SR instance on EN2 in ATL on VLAN 22
resource "nsxt_policy_tier0_gateway_interface" "ATL_LAB-T0-EN2-Uplink-22" {
  display_name   = "ATL_LAB-T0-EN2-Uplink-22"
  type           = "EXTERNAL"
  site_path      = data.nsxt_policy_site.ATL.path
  gateway_path   = nsxt_policy_tier0_gateway.LAB-T0.path
  edge_node_path = data.nsxt_policy_edge_node.ATL-EN2.path
  segment_path   = nsxt_policy_vlan_segment.ATL_LAB-T0-Uplink-22.path
  subnets        = ["10.100.22.3/24"]
  tag {
    tag = "Managed by Terraform"
  }
}