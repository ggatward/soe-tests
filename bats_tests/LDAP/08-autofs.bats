#!/usr/bin/env bats

TESTUSER="geoff"

# Check autofs is running
@test "autofs: autofs is running" {
  run bash -c "./checkservices.bash autofs"
  [ $status -eq 0 ]
}

@test "autofs: NFS home directories function" {
  run bash -c "ls /home/geoff 2>/dev/null"
  run bash -c "mount | cut -f3 -d' ' | grep '^/home/geoff$'"
  [ $status -eq 0 ]
  [ "$output" == "/home/geoff" ]
}

@test "autofs: NFS home directory maps ownership correctly" {
  run bash -c "ls -ld /home/geoff | cut -d' ' -f 3"
  [ $status -eq 0 ]
  [ "$output" == "geoff" ]
}

@test "autofs: NFSv4 configuration applied by Puppet module" {
  run bash -c "cat /etc/idmapd.conf | grep "^Domain" | grep home.gatwards.org"
  [ $status -eq 0 ]
}
