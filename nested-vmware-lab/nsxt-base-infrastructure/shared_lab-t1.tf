resource "nsxt_policy_tier1_gateway" "Shared_LAB-T1" {
  display_name              = "Shared_LAB-T1"
  tier0_path                = nsxt_policy_tier0_gateway.LAB-T0.path
  route_advertisement_types = ["TIER1_CONNECTED"]
  pool_allocation           = "ROUTING"

  tag {
    tag = "Managed by Terraform"
  }
}
