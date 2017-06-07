#!/usr/bin/env bats

@test "Filesystems: /home mountpoint exists" {
  run bash -c "mount | grep -e ".*vg_sys-home""
  [ $status = 0 ]
}

@test "Filesystems: /tmp mountpoint exists" {
  run bash -c "mount | cut -f3 -d' ' | grep '^/tmp$'"
  [ "$output" == "/tmp" ]
}

@test "Filesystems: /var mountpoint exists" {
  run bash -c "mount | cut -f3 -d' ' | grep '^/var$'"
  [ "$output" == "/var" ]
}

@test "Filesystems: /var/log mountpoint exists" {
  run bash -c "mount | cut -f3 -d' ' | grep '^/var/log$'"
  [ "$output" == "/var/log" ]
}

@test "Filesystems: /var/log/audit mountpoint exists" {
  run bash -c "mount | cut -f3 -d' ' | grep '^/var/log/audit$'"
  [ "$output" == "/var/log/audit" ]
}
