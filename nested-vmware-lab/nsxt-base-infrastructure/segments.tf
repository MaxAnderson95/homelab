locals {
  domain_name = "lab.maxanderson.tech"
}

resource "nsxt_policy_segment" "ST-LAN-01" {
  display_name      = "ST-LAN-01"
  connectivity_path = nsxt_policy_tier1_gateway.ST-T1-01.path
  domain_name       = local.domain_name

  subnet {
    cidr = "172.23.128.1/24"
  }

  tag {
    tag = "Managed by Terraform"
  }

  tag {
    tag   = "LAN"
    scope = "Zone"
  }
}

resource "nsxt_policy_segment" "ATL-LAN-01" {
  display_name      = "ATL-LAN-01"
  connectivity_path = nsxt_policy_tier1_gateway.ATL-T1-01.path
  domain_name       = local.domain_name

  subnet {
    cidr = "172.23.160.1/24"
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
  connectivity_path = nsxt_policy_tier1_gateway.NYC-T1-01.path
  domain_name       = local.domain_name

  subnet {
    cidr = "172.23.192.1/24"
  }

  tag {
    tag = "Managed by Terraform"
  }

  tag {
    tag   = "LAN"
    scope = "Zone"
  }
}
