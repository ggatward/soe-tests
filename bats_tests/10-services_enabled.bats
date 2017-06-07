#!/usr/bin/env bats
# Check required services are running, in one test.

# PLEASE KEEP THE SERVICES IN VARIABLES IN *ALPHABETICAL* ORDER TO PRESERVE THE SANITY OF PEOPLE
# MODIFYING THIS IN THE FUTURE!!

# Common services:
commonservices="auditd crond puppet rsyslog sshd sssd"
##             restorecond (minimal help?) sysstat (splunk anyway?)
# Note that autofs/oddjobd , nscd and yum-cron are tested elsewhere.

# Operating system-specific services:
rhel6services="acpid ntpd"
rhel7services="chronyd"

# Platform-specific services:
physicalservices="rngd"
#  Note that virtualisation agents, if required, are already tested elsewhere.


@test "Enabled Services: Required services are running" {
  rel=$(cat /etc/redhat-release | awk '{ print int($7)}')
  if [ ${rel} -ge 7 ]
  then
    if [ $(virt-what) == "" ]
    then
      run "./checkservices.bash" ${commonservices} ${rhel7services} ${physicalservices}
    else
      run "./checkservices.bash" ${commonservices} ${rhel7services}
    fi
  else
    if [ $(virt-what) == "" ]
    then
      run "./checkservices.bash" ${commonservices} ${rhel6services} ${physicalservices}
    else
      run "./checkservices.bash" ${commonservices} ${rhel6services}
    fi

  fi
  [ "$status" -eq 0 ]
  [ "$output" = "All services are running." ]
}
