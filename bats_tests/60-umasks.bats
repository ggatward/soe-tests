#!/usr/bin/env bats
# Functional tests to prove umasks are hardened for ISM requirements.

load setup-test-environment

@test "ISM umasks: root umask is hardened (0077)" {
  run bash -c "umask | grep 0077"
  [ ${status} -eq 0 ]
}


@test "ISM umasks: New user's umask is hardened (0077)" {
  useradd -m -d /opt/umask-test-user umask-test-user > /dev/null 2>&1
  run bash -c "su - umask-test-user -c "umask" | tail -1 | grep 0077"
  [ ${status} -eq 0 ]
  # Cleanup - believe it or not, doing this userdel here doesn't break bats!
  userdel -r umask-test-user
}


# On RHEL 6 only, check that the default service umask is hardened.
if [ ${rel} -eq 6 ]
then
  TESTNAME="ISM umasks: RHEL6 Default service umask is hardened (027)"
  TOTEST=1
else
  TESTNAME="ISM umasks: SKIPPED! 'systemd' doesn't allow service umasks to be changed globally"
  TOTEST=0
fi

@test "${TESTNAME}" {
  if [ TOTEST -eq 1 ]; then
    # Use an external script to use the GNU Debugger to get the umask of an active process.
    #  Note that doing so temporarily interrupts the process and its threads!
    run bash -c "./60-procumask.bash ruby | grep 027"
    # NOTE: While testing this I've found that even on hardened systems process umasks can vary!
    #       Selected 'ruby' as it is always running for the puppet agent.
  else
    # Dodgy hack to work around skipped tests appearing as fails.  Don't actually run the test!
    run bash -c "status=0"
  fi
  [ ${status} -eq 0 ]
}

