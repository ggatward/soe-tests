#!/usr/bin/env bats

TESTUSER="geoff"

# Check oddjobd is running
@test "LocalHomes: oddjobd is running" {
  run bash -c "../checkservices.bash oddjobd"
  [ $status -eq 0 ]
}

#Check if the oddjobd pam module is loaded
@test "LocalHomes: Pam Modules Present" {
  run bash -c "grep oddjob /etc/pam.d/system-auth-ac"
  [ $status -eq 0 ]
}

#SU as the TESTUSER to create a home directory and test the home dir is created
@test "LocalHomes: Local Home Dirs Functioning" {
    run bash -c "su -c 'logout' - $TESTUSER"
    run bash -c "ls -l /home/$TESTUSER"
    [ $status -eq 0 ]
}

#Check if the ownership of the home directory is set to the TESTUSER
@test "LocalHomes: Local Home directory maps ownership correctly" {
  run bash -c "ls -ld /home/$TESTUSER | cut -d' ' -f 3"
  [ $status -eq 0 ]
  [ "$output" == $TESTUSER ]
}
