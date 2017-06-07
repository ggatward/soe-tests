#!/usr/bin/env bats
# Check unwanted services are not running, in one test.


# PLEASE KEEP THE SERVICES IN VARIABLES IN *ALPHABETICAL* ORDER TO PRESERVE THE SANITY OF PEOPLE
# MODIFYING THIS IN THE FUTURE!!

commonservices="abrtd abrt-ccpp avahi-daemon bluetooth cups ip6tables kdump postfix sendmail"

# Operating system-specific services:
rhel6services="NetworkManager"
rhel7services=""

# Platform-specific services:
physicalservices="vmtoolsd"
virtualservices="rngd"


@test "Disabled Services: No unwanted services are running" {
  rel=$(cat /etc/redhat-release | awk '{ print int($7)}')
  if [ ${rel} -ge 7 ]
  then
    if [ $(virt-what) == "" ]
    then
      run "./checkservices.bash" ${commonservices} ${rhel7services} ${physicalservices}
    else
      run "./checkservices.bash" ${commonservices} ${rhel7services} ${virtualservices}
    fi
  else
    if [ $(virt-what) == "" ]
    then
      run "./checkservices.bash" ${commonservices} ${rhel6services} ${physicalservices}
    else
      run "./checkservices.bash" ${commonservices} ${rhel6services} ${virtualservices}
    fi

  fi
  [ "$status" -eq 1 ]
  [ "$output" = "No services are running." ]
}
