#!/usr/bin/env bats

@test "SOE MISC: SOE Release File Exists" {
  run bash -c "ls /etc/soe-release"
  [ $status -eq 0 ]
}
