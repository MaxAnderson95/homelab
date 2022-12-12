locals {
  domain_name = "lab.maxanderson.tech"
}

resource "nsxt_policy_segment" "ATL-LAN-01" {
  display_name      = "ATL-LAN-01"
  connectivity_path = nsxt_policy_tier1_gateway.ATL_LAB-T1.path
  domain_name       = local.domain_name

  subnet {
    cidr = "172.21.1.1/24"
  }

  tag {
    tag = "Managed by Terraform"
  }

  tag {
    tag   = "LAN"
    scope = "Zone"
  }
}

resource "nsxt_policy_segment" "NYC-LAN-01" {
  display_name      = "NYC-LAN-01"
  connectivity_path = nsxt_policy_tier1_gateway.NYC_LAB-T1.path
  domain_name       = local.domain_name

  subnet {
    cidr = "172.22.1.1/24"
  }

  tag {
    tag = "Managed by Terraform"
  }

  tag {
    tag   = "LAN"
    scope = "Zone"
  }
}

resource "nsxt_policy_segment" "Shared-LAN-01" {
  display_name      = "Shared-LAN-01"
  connectivity_path = nsxt_policy_tier1_gateway.Shared_LAB-T1.path
  domain_name       = local.domain_name

  subnet {
    cidr = "172.23.1.1/24"
  }

  tag {
    tag = "Managed by Terraform"
  }

  tag {
    tag   = "LAN"
    scope = "Zone"
  }
}
