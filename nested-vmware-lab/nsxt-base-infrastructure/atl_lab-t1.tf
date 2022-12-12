resource "nsxt_policy_tier1_gateway" "ATL_LAB-T1" {
  display_name              = "ATL_LAB-T1"
  tier0_path                = nsxt_policy_tier0_gateway.LAB-T0.path
  route_advertisement_types = ["TIER1_CONNECTED"]
  pool_allocation           = "ROUTING"
  failover_mode             = "NON_PREEMPTIVE"

  locale_service {
    edge_cluster_path = data.nsxt_policy_edge_cluster.ATL.path
  }

  intersite_config {
    primary_site_path = data.nsxt_policy_site.ATL.path
  }

  tag {
    tag = "Managed by Terraform"
  }
}
