#!/usr/bin/env bats

@test "Users: unmwanted users have been removed" {
  USER_DEL="ftp news uucp operator games gopher pcap"

  for user in $USER_DEL
  do
    run bash -c "grep ^$user /etc/passwd > /dev/null"
    [ $status -ne 0 ]
  done
}

@test "Users: unmwanted groups have been removed" {
  GROUP_DEL="games"

  for group in $GROUP_DEL
  do
    run bash -c "grep ^$group /etc/group > /dev/null"
    [ $status -ne 0 ]
  done
}
