#!/usr/bin/env bats

@test "Authentication: Can lookup username (geoff)" {
  run bash -c "getent passwd geoff"
  [ $status -eq 0 ]
}

@test "Authentication: Can lookup group (admins)" {
  run bash -c "getent group admins"
  [ $status -eq 0 ]
}

@test "Authentication: Can lookup netgroup (role-unix-support)" {
  run bash -c "getent netgroup role-unix-support"
  [ $status -eq 0 ]
}


