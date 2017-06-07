#!/usr/bin/env bats
# Check that firewall is implemented

# Check that firewall is running
rel=$(cat /etc/redhat-release | awk '{ print int($7)}')

@test "Firewall: running" {
  if [ ${rel} -ge 7 ]
  then
    run bash -c "./checkservices.bash firewalld"
    [ ${status} -eq 0 ]
  else
    run bash -c "./checkservices.bash iptables"
    [ ${status} -eq 0 ]
  fi
}

@test "Firewall: Required ports open - SSH" {
  if [ ${rel} -ge 7 ]
  then
    run bash -c "./25-firewall-test.bash | grep ssh"
  else
    run bash -c "./25-firewall-test.bash | grep 22"
  fi
  [ "$status" -eq 0 ]
}
