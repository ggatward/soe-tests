#!/bin/bash

do_setup()
{
# Set up for Authentication Testing used by authentication.bats

#Install pamtester and expect packages
yum -q -y install sshpass pamtester expect >/dev/null 2>&1

# Copy original /etc/login.defs
cp -p /etc/login.defs /etc/login.defs.pretest >/dev/null 2>&1

# Change the shadow password for new users temporarily
sed -i 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS   1/' /etc/login.defs >/dev/null 2>&1

sed -i 's/^PASS_MIN_DAYS.*/PASS_MIN_DAYS  -1/' /etc/login.defs >/dev/null 2>&1

# Create two local user accounts with homedirs in /opt for testing
useradd -m -d /opt/localtest1 localtest1 >/dev/null 2>&1
useradd -m -d /opt/localtest2 localtest2 >/dev/null 2>&1
}

do_setup

