################### ATL ###################
data "nsxt_policy_site" "ATL" {
  display_name = "ATL"
}

data "nsxt_policy_edge_cluster" "ATL" {
  display_name = "ATL-Edge-Cluster"
  site_path    = data.nsxt_policy_site.ATL.path
}

data "nsxt_policy_edge_node" "ATL-EN1" {
  edge_cluster_path = data.nsxt_policy_edge_cluster.ATL.path
  display_name      = "ATL-EDGE-01"
}

data "nsxt_policy_edge_node" "ATL-EN2" {
  edge_cluster_path = data.nsxt_policy_edge_cluster.ATL.path
  display_name      = "ATL-EDGE-02"
}

data "nsxt_policy_transport_zone" "ATL_default_vlan" {
  display_name   = "nsx-vlan-transportzone"
  transport_type = "VLAN_BACKED"
  site_path      = data.nsxt_policy_site.ATL.path
}

################### NYC ###################
data "nsxt_policy_site" "NYC" {
  display_name = "NYC"
}

data "nsxt_policy_edge_cluster" "NYC" {
  display_name = "NYC-Edge-Cluster"
  site_path    = data.nsxt_policy_site.NYC.path
}

data "nsxt_policy_edge_node" "NYC-EN1" {
  edge_cluster_path = data.nsxt_policy_edge_cluster.NYC.path
  display_name      = "NYC-EDGE-01"
}

data "nsxt_policy_edge_node" "NYC-EN2" {
  edge_cluster_path = data.nsxt_policy_edge_cluster.NYC.path
  display_name      = "NYC-EDGE-02"
}

data "nsxt_policy_transport_zone" "NYC_default_vlan" {
  display_name   = "nsx-vlan-transportzone"
  transport_type = "VLAN_BACKED"
  site_path      = data.nsxt_policy_site.NYC.path
}