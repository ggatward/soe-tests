#!/usr/bin/env bats

@test "sudo: netgroup has full sudo privileges" {
  run bash -c "cat /etc/sudoers.d/role-unix-support | grep -v ^#"
  [ $status -eq 0 ]
  [ "${lines[0]}" = "+role-unix-support    ALL=(ALL) ALL" ]
}
# Or use this for the test, which won't be affected by whitespace changes:
##run bash -c 'grep -q -e ^"+role-unix-support\s*ALL=(ALL)\s(ALL" /etc/security/access.conf'

@test "sudo: 'wheel' group does not have sudo access" {
  run bash -c "grep -q ^'%wheel' /etc/sudoers"
  [ $status -ne 0 ]
}
