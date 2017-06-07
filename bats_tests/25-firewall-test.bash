#!/bin/bash
# Script used by tests in 25-firewall.bats

rel=$(cat /etc/redhat-release | awk '{ print int($7)}')

# turn on the firewall
#if [ ${rel} -ge 7 ]
#then
#  systemctl start firewalld.service
#else
#  service iptables start
#fi

# display firewall rules
if [ ${rel} -ge 7 ]
then
  firewall-cmd --list-all
else
  iptables -L -v -n
fi

# Turn off firewall
#if [ ${rel} -ge 7 ]
#then
#  systemctl stop firewalld.service
#else
#  service iptables stop
#fi
