#!/bin/bash
# Using 'getent hosts' check that nscd is correctly caching hosts

do_setup()
{
  # This test ignores puppet as stopping and starting it for the test causes BATS to fail.

  # Reconfigure nscd.conf
  ## ensure log file is set
  sed -Ei 's/.*logfile\s.*\/var\/log\/nscd.log/        logfile                 \/var\/log\/nscd.log/g' /etc/nscd.conf
  ## ensure debug is set
  sed -Ei 's/.*debug-level.*/         debug-level             2/g' /etc/nscd.conf
  # restart nscd, because persistent hosts cache is not set this will wipe that cache.
  service nscd restart > /dev/null
  if [ $? -ne 0 ]; then
    echo "nscd did not restart gracefully.  Is it configured correctly?"
    exit 1
  fi
}

do_cleanup()
{
  # reconfigure nscd.conf
  ## unset log file again
  sed -Ei 's/\s.*logfile.*/#       logfile                 \/var\/log\/nscd.log/g' /etc/nscd.conf
  ## unset debug
  sed -Ei 's/\s.*debug-level.*/#       debug-level             0/g' /etc/nscd.conf
  # restart nscd
  service nscd restart > /dev/null
  # clear log file
  > /var/log/nscd.log
}


########## TEST EXECUTION ##########

do_setup

# Sleep half a second, to ensure nscd is ready to cache
sleep 0.5

# Test must used 'getent' instead of "host" or "dig" commands in order to query hosts cache.
# Using 'ahostsv4' ensures that IPv6 queries aren't made, which can confuse this script.
getent ahostsv4 ntp3.core.home.gatwards.org > /dev/null && grep -q 'add new entry "ntp3.core.home.gatwards.org" of type GETAI for hosts to cache (first)' /var/log/nscd.log
if [ $? -ne 0 ]; then
  EXITVAL=$?
  echo "Not added to the hosts cache.  Has this host been queried earlier?"
  do_cleanup
  exit ${EXITVAL}
fi

# Due to the way NSCD works we must wait up to 5 seconds
sleep 5

# Do a second hosts lookup, this one should be now be cached
getent ahostsv4 ntp3.core.home.gatwards.org > /dev/null && grep -qv 'add new entry "ntp3.core.home.gatwards.org" of type' /var/log/nscd.log
if [ $? -ne 0 ]; then
  EXITVAL=$?
  echo "Second hosts query was not cached!"
  do_cleanup
  exit ${EXITVAL}
fi

do_cleanup

