#!/bin/bash
# Utility used with service checks including:
#  10-enabled_services.bats 11-disabled-services.bats tests and 35-nscd-hosts.bats

services=${@}
VER=$(cat /etc/redhat-release | awk '{ print int($7)}')
COUNTER=0
FAILED=0

if [[ ${services} == "" ]]; then
  echo "ERROR: No service names supplied."
  exit 99
fi

# Check each service individually
for SERVICE in ${services}
do
  if [ ${VER} -ge 7 ]; then
    COUNTER=$((COUNTER+1))
    systemctl status ${SERVICE} > /dev/null 2>&1
  else
    COUNTER=$((COUNTER+1))
    service ${SERVICE} status > /dev/null 2>&1
  fi
  if [ $? -ne 0 ]; then
    # Increment failed variable
    FAILED=$((FAILED+1))
  fi
done

# Determine result
if [ ${FAILED} -eq 0 ]; then
  echo "All services are running."
  exit 0
else
  if [ ${FAILED} -eq ${COUNTER} ]; then
    echo "No services are running."
    exit 1
  else
    echo "Only some services are running."
    exit 2
  fi
fi
