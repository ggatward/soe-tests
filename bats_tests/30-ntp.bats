#!/usr/bin/env bats
load setup-test-environment

# The service check is performed in the running_services test case

@test "NTP: System time in sync" {
  [ $ntpstratum -lt 10 ]
}
