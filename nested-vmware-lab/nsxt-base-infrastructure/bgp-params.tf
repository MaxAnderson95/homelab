locals {
  bgp_hold_down_time    = 9
  bgp_keep_alive_time   = 3
  bfd_interval          = 500
  bfd_multiple          = 2
  graceful_restart_mode = "HELPER_ONLY"
  nsx_as_num            = 65400
  atl_peer_as_num       = 65100
  nyc_peer_as_num       = 65200
}
