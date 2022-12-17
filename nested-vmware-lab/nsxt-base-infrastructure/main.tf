terraform {
  required_providers {
    nsxt = {
      source  = "vmware/nsxt"
      version = "3.2.8"
    }
  }
  cloud {
    organization = "maxanderson95"

    workspaces {
      name = "nsxt-base-infrastructure"
    }
  }
}

provider "nsxt" {
  host                 = "atl-nsx-global-mgr.lab.maxanderson.tech"
  username             = "admin"
  password             = ""
  allow_unverified_ssl = true
  global_manager       = true
}
