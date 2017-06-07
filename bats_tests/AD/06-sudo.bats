#!/usr/bin/env bats

@test "sudo: AD group has full sudo privileges" {
  run bash -c "cat /etc/sudoers.d/ad-admins | grep -v ^#"
  [ $status -eq 0 ]
  [ "${lines[0]}" = "+role-unix-support    ALL=(ALL) ALL" ]
}

@test "sudo: 'wheel' group does not have sudo access" {
  run bash -c "grep -q ^'%wheel' /etc/sudoers"
  [ $status -ne 0 ]
}
