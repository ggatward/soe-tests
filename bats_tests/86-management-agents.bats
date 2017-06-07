#!/usr/bin/env bats
#
#
# Test to see if netbackup agent is install

#rel=$(facter operatingsystemmajrelease)
#export rel

#@test "Backup: NetBackup client is installed" {
#if [ ${rel} -ge 7 ]
#then
#    run bash -c "rpm -q netbackup*"
#    [ $status -eq 0 ]
#else
#    run bash -c "rpm -q netbackup"
#    [ $status -eq 0 ]
#fi
#}

# Test to see if salt agent is installed
#@test "Command Dispatcher: Salt minion is installed" {
#    run bash -c "rpm -q salt-minion"
#    [ $status -eq 0 ]
#}


# Test to see if nagios nrpe is installed
#@test "Monitoring Agent: nrpe client is installed" {
#    run bash -c "rpm -q nrpe"
#    [ $status -eq 0 ]
#}
