#!/bin/bash
# Script used by tests in 60-ssh_hardening.bats.  Each run returns the system to its previous state.

RESULT=1
SSHDOK="false"
PUBKEYOK="false"

## Parse input #####################################################################################
# If necessary, use fancy getopts and big case statement with shift, but for now...
# GARBAGE IN GARBAGE OUT!
OPTIONS="$@"


## Preparation #####################################################################################
## If needed, enable root login via ssh and restart sshd.
#if (grep -q -E "^PermitRootLogin\syes" /etc/ssh/sshd_config); then
  #SSHDOK="true"
#else
  #sed -i 's/^PermitRootLogin\s.*no/PermitRootLogin yes/g' /etc/ssh/sshd_config
  #service sshd restart > /dev/null 2>&1
  ## Sleep to prevent these tests causing systemd to complain about sshd restarting too rapidly
  #sleep 2
#fi

# If needed generate ISM-compliant SSH keys for root, with no password for automated testing
if [ -f /root/.ssh/id_ecdsa ]; then
  PUBKEYOK="true"
else
  /usr/bin/ssh-keygen -q -t ecdsa -b 384 -f /root/.ssh/id_ecdsa -N ''
  cat /root/.ssh/id_ecdsa.pub >> /root/.ssh/authorized_keys
fi


## Actual test #####################################################################################
# Generate unique identifier for this test (time since epoch)
UNIQ=$(date +%s)
echo "${UNIQ}" > /root/ssh-test-file

# Use scp in lieu of ssh, because it can do something testable without user input.
  scp -q ${OPTIONS} -o StrictHostKeyChecking=no -o PasswordAuthentication=no -o GSSAPIAuthentication=no /root/ssh-test-file localhost:/tmp
  if [ $? -eq 0 ]; then
    # The unique number $UNIQ in the test file was copied correctly
    if [ $(cat /tmp/ssh-test-file) -eq ${UNIQ} ]; then
      RESULT=0
    fi
  fi


## Clean up, if needed #############################################################################
# If SSH public keys were created for this test, then remove them.
if [ ${PUBKEYOK} == "false" ]; then
  sed -i '/ecdsa-sha2-nistp384/d' /root/.ssh/authorized_keys
  rm -f /root/.ssh/id_ecdsa /root/.ssh/id_ecdsa.pub
fi

# If root login was previously enabled, disable it again.
#if [ ${SSHDOK} == "false" ]; then
  #sed -i 's/^PermitRootLogin\s.*yes/PermitRootLogin no/g' /etc/ssh/sshd_config
  #service sshd restart > /dev/null 2>&1
  ## Sleep to prevent these tests causing systemd to complain about sshd restarting too rapidly
  #sleep 2
#fi


# Regardless of other commands, the main test result is what should be returned to BATS
exit ${RESULT}

## End #############################################################################################
