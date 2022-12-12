locals {
  bgp_hold_down_time    = 9
  bgp_keep_alive_time   = 3
  bfd_interval          = 500
  bfd_multiple          = 2
  graceful_restart_mode = "HELPER_ONLY"
  local_as_num          = 65300
  atl_peer_as_num       = 65100
  nyc_peer_as_num       = 65200
  atl_nsx_prefix        = "172.21.0.0/16"
  nyc_nsx_prefix        = "172.22.0.0/16"
  stretched_nsx_prefix  = "172.23.0.0/16"
}

#Top level stretched T0
resource "nsxt_policy_tier0_gateway" "LAB-T0" {
  display_name = "LAB-T0"
  ha_mode      = "ACTIVE_ACTIVE"

  locale_service {
    edge_cluster_path = data.nsxt_policy_edge_cluster.ATL.path
  }

  locale_service {
    edge_cluster_path = data.nsxt_policy_edge_cluster.NYC.path
  }

  tag {
    tag = "Managed by Terraform"
  }
}
