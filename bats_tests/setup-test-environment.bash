#!/bin/sh

# Determine the RHEL major release number
rel=$(cat /etc/redhat-release | awk '{ print int($7)}')
export rel

if [ $rel -ge 7 ]; then
  ntpstratum=$(chronyc tracking | grep Stratum | awk '{ print $3 }')
else
  ntpstratum=$(echo rv | ntpq | grep stratum | cut -f2 -d= | cut -f1 -d,)
fi
export ntpstratum
