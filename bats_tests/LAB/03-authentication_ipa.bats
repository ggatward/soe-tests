#!/usr/bin/env bats

@test "Authentication: Can lookup username from IPA (geoff)" {
  run bash -c "getent passwd geoff"
  [ $status -eq 0 ]
}

@test "Authentication: Can lookup group from IPA (admins)" {
  run bash -c "getent group family"
  [ $status -eq 0 ]
}

#@test "Authentication: Can lookup netgroup from IPA (role-unix-support)" {
#  run bash -c "getent netgroup role-unix-support"
#  [ $status -eq 0 ]
#}


