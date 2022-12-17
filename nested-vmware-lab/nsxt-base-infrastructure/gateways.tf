#Top level stretched T0
resource "nsxt_policy_tier0_gateway" "ST-T0-01" {
  display_name = "ST-T0-01"
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

resource "nsxt_policy_tier1_gateway" "ST-T1-01" {
  display_name              = "ST-T1-01"
  tier0_path                = nsxt_policy_tier0_gateway.ST-T0-01.path
  route_advertisement_types = ["TIER1_CONNECTED"]
  pool_allocation           = "ROUTING"

  tag {
    tag = "Managed by Terraform"
  }
}

resource "nsxt_policy_tier1_gateway" "ATL-T1-01" {
  display_name              = "ATL-T1-01"
  tier0_path                = nsxt_policy_tier0_gateway.ST-T0-01.path
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

resource "nsxt_policy_tier1_gateway" "NYC-T1-01" {
  display_name              = "NYC-T1-01"
  tier0_path                = nsxt_policy_tier0_gateway.ST-T0-01.path
  route_advertisement_types = ["TIER1_CONNECTED"]
  pool_allocation           = "ROUTING"
  failover_mode             = "NON_PREEMPTIVE"

  locale_service {
    edge_cluster_path = data.nsxt_policy_edge_cluster.NYC.path
  }

  intersite_config {
    primary_site_path = data.nsxt_policy_site.NYC.path
  }

  tag {
    tag = "Managed by Terraform"
  }
}
