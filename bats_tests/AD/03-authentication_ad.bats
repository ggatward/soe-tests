#!/usr/bin/env bats

@test "Authentication: Can lookup username from AD (geoff)" {
  run bash -c "getent passwd geoff"
  [ $status -eq 0 ]
}

@test "Authentication: Can lookup group from AD (admins)" {
  run bash -c "getent group admins"
  [ $status -eq 0 ]
}

