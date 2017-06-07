#!/usr/bin/env bats
# Check the /etc/security/access.conf is configured correctly.

@test "Access: LDAP netgroup has 'ALL' access" {
  run bash -c 'grep -q -e ^"+\s*:\s*@role-unix-support\s*:\s*ALL" /etc/security/access.conf'
  [ $status -eq 0 ]
}

#@test "Access: netgroup for local server exists, and has 'ALL' access" {
#  run bash -c 'grep -q -e ^"+\s*:\s*@access-${HOSTNAME}\s*:\s*ALL" /etc/security/access.conf'
#  [ $status -eq 0 ]
#}

@test "Access: locally, any user has access" {
  run bash -c 'grep -q -e ^"+\s*:\s*ALL\s*:\s*LOCAL" /etc/security/access.conf'
  [ $status -eq 0 ]
}

@test "Access: 'gdm' has access (in case X11 is ever installed)" {
  run bash -c 'grep -q -e ^"+\s*:\s*gdm\s*:\s*ALL" /etc/security/access.conf'
  [ $status -eq 0 ]
}

@test "Access: All other users are denied access" {
  run bash -c 'grep -q -e ^"-\s*:\s*ALL\s*:\s*ALL" /etc/security/access.conf'
  [ $status -eq 0 ]
}

