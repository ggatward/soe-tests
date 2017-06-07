#!/usr/bin/env bats

SERVER=`cat /etc/rhsm/rhsm.conf | grep '^hostname\s\=' | awk '{ print $3 }'`

@test "CA Trust: Certificate store includes Root Certificate Authority" {
  run bash -c 'ls -al /etc/pki/ca-trust/source/anchors/| grep 'GatwardIT-Root-CA\.pem''
  [ $status -eq 0 ]
}

@test "CA Trust: GatwardIT Root CA is trusted when using TLS" {
  run bash -c "echo "" | openssl s_client -connect $SERVER:443 | grep -i 'verify return code: 0 (ok)'"
  [ $status -eq 0 ]
}

