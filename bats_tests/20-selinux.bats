#!/usr/bin/env bats

@test "SELinux: SELinux is actively enforcing" {
  run bash -c "getenforce | grep Enforcing"
  [ $status -eq 0 ]
}

@test "SELinux: Configuration file is set to 'enforcing'" {
  run bash -c "sestatus | grep Mode | grep -q enforcing"
  [ $status -eq 0 ]
}

@test "SELinux: No denials occurred during Kickstart" {
  run bash -c "ausearch -m avc 2>&1 | head | grep '<no matches>'"
  [ $status -eq 0 ]
}

@test "SELinux: use_nfs_home_dirs boolean is enabled" {
  run bash -c "getsebool use_nfs_home_dirs | grep -q on$"
  [ $status -eq 0 ]
}
