terraform {
  required_providers {
    nsxt = {
      source  = "vmware/nsxt"
      version = "3.2.8"
    }
  }
}

provider "nsxt" {
  host                 = "atl-nsx-global-mgr.lab.maxanderson.tech"
  allow_unverified_ssl = true
  global_manager       = true
}

provider "nsxt" {
  host                 = "atl-nsx-local-mgr.lab.maxanderson.tech"
  allow_unverified_ssl = true

  alias = "atl"
}

provider "nsxt" {
  host                 = "nyc-nsx-local-mgr.lab.maxanderson.tech"
  allow_unverified_ssl = true

  alias = "nyc"
}