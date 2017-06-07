#!/bin/bash
# Get the umask for a running process
# Based on: unix.stackexchange.com/questions/258284/current-umask-of-a-process-with-pid

# While this could be done with systemtap, it requires kernel debugging packages we don't have!

if [ ${#} -eq 0 ]
then
  echo "${0} Error: No process name supplied."
else
  TESTPID=$(pidof ${1} | cut -d' ' -f1)
  if [ $? -ne 0 ]
  then
    echo "${0} Error: process named \"${1}\" not found." ; exit 1
  else
    rpm --quiet -q gdb
    if [ $? -ne 0 ]
    then
      yum install -q -y gdb > /dev/null
    fi
    # Use the GNU Debugger to halt a PID, get its umask value then set the umask back to that value.
    gdb --batch -ex 'call/o umask(0)' -ex 'call umask($1)' --pid=${TESTPID} | awk '$1 == "$1" { print $3}'
  fi
fi

