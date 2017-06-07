#!/usr/bin/env bats

# Ensure the audit agent is installed
@test "ISM Audit: audit is installed" {
  run bash -c "rpm -q audit"
  [ ${status} -eq 0 ]
}


@test "ISM Audit: auditd is running" {
  cat /var/log/audit/audit.log > /dev/null 2>&1
  #Issue a command then check if the audit captured the command
  run "grep 'EXECVE.*\/var\/log\/audit\/audit.log' /var/log/audit/audit.log"
  [ $? -eq 0 ]
}


# Ensure the Host-based Intrusion Detection Software (HIDS) is installed and prelink has
# been disabled.  (Prelinking improves the time to launch an application but causes false
# positives for HIDS.)
@test "ISM HIDS: HIDS package (aide) is installed" {
  run bash -c "rpm -q aide"
  [ ${status} -eq 0 ]
}

@test "ISM HIDS: Prelinking is disabled in configuration" {
  run bash -c "grep '^PRELINKING=yes' /etc/sysconfig/prelink"
  [ ${status} -ne 0 ]
}

