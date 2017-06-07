#!/usr/bin/env bats
# Check that nscd is implemented as desired 


# Check that nscd is running
#@test "DNS cache: nscd is running" {
#  run bash -c "./checkservices.bash nscd"
#  [ $status -eq 0 ]
#}

# Check that hosts are actually cached
#@test "DNS cache: nscd caches IP for 'ntp3.home.gatwards.org'" {
#  run bash -c "./35-nscd-check.bash"
#  [ $status -eq 0 ]
#}
