#!/usr/bin/env bats

@test "sudo: 'wheel' group does not have sudo access" {
  run bash -c "grep -q ^'%wheel' /etc/sudoers"
  [ $status -ne 0 ]
}
