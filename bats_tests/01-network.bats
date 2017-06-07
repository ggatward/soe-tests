#!/usr/bin/env bats

@test "Network: Gateway can be pinged" {
  gw=$(ip route show | grep default | cut -d" " -f3)
  run ping -c 1 ${gw}
  [ $status -eq 0 ]
}

@test "Network: ntp1.core.home.gatwards.org can be resolved" {
  run nslookup ntp1.core.home.gatwards.org
  [ $status -eq 0 ]
}
