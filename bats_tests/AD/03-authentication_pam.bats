#!/usr/bin/env bats

# Setup testing environment
@test "Authentication: PAM Setup Test ENV" {
  run bash -c "./setup-auth-test-environment.bash"
}

# Testing for setting Passwords that are blank 
@test "Authentication: PAM is preventing blank passwords" {
  run bash -c "echo -e '\n\n\n\n\n' | passwd localtest1"
  [ $status -eq 1 ]
}

# Testing passwords too short
@test "Authentication: PAM is preventing passwords that are too short" {
  run bash -c "echo 'fred' | passwd localtest1"
  [ $status -eq 1 ]
}

# Testing passwords that are dictionary words
@test "Authentication: PAM is preventing passwords that fail the dictionary check" {
  run bash -c "echo 'greenhouse@3' | passwd localtest1"
  [ $status -eq 1 ]
}

# Testing for changing to passwords that are valid
@test "Authentication: PAM is allowing changing to correct password types" {
  run bash -c "echo -e 'cat\ herder1\ncat\ herder1' | passwd localtest1"
  [ $status -eq 0 ]
}

# Testing user changing to new valid password
@test "Authentication: PAM is allowing user to change to a new correct password" {
  run su - localtest1 -c "echo -e 'cat\ herder1\n\!QAZ2wsx#EDC\n\!QAZ2wsx#EDC' | passwd"
  [ $status -eq 0 ]
}

# Testing user changing to new valid password
@test "Authentication: PAM is allowing user to change to another correct password" {
  run su - localtest1 -c "echo -e '\!QAZ2wsx#EDC\n@WSX3edcRFV\n@WSX3edcRFV' | passwd"
  [ $status -eq 0 ]
}

# Testing user is not allowed to re-use a password
@test "Authentication: PAM does not allow password re-use" {
  run su - localtest1 -c "echo -e '@WSX3edcRFV\n\!QAZ2wsx#EDC\n\!QAZ2wsx#EDC' | passwd"
  [ $status -eq 1 ]
}

# Testing for SSH login 
@test "Authentication: PAM does not allow ssh access for users not in access.conf" {
  run bash -c "sshpass -p '@WSX3edcRFV' ssh -o StrictHostKeyChecking=no localtest1@`hostname`"
  [ $status -ne 0 ]
}

# Testing faillock via ssh. Setup the test user to be allowed to ssh by adding to access.conf
# Try to login via ssh 6 times with wrong password to trigger faillock
@test "Authentication: PAM Setup faillock env" {
  run cp -p /etc/security/access.conf /etc/security/access.conf.pretest
  run sed -i '$1'"+ : localtest1 : ALL" /etc/security/access.conf
}

@test "Authentication: PAM Creating faillock condition" {
  run bash -c "for i in {1..6}; do sshpass -p wrongpass ssh -o StrictHostKeyChecking=no localtest1@`hostname`; done"
}

# Test if faillock has been set for localtest1
@test "Authentication: PAM Faillock has been triggered" {
  run grep -e ".*faillock.*test1.*locked" /var/log/secure
  [ $status -eq 0 ]
}

# Testing a faillocked locked account
@test "Authentication: User cannot login to locked account" {
  run bash -c "sshpass -p '@WSX3edcRFV' ssh -o StrictHostKeyChecking=no localtest1@`hostname`"
  [ $status -ne 0 ]
}

# Unlocking faillocked account
@test "Authentication: Unlocking faillocked user account" {
  run bash -c "faillock --user localtest1 --reset"
  [ $status -eq 0 ]
}

# Testing user can login after unlock
@test "Authentication: User can login after account is unlocked" {
  run bash -c "sshpass -p '@WSX3edcRFV' ssh -o StrictHostKeyChecking=no localtest1@`hostname` exit"
  [ $status -eq 0 ]
}

# Return environment to normal
@test "Authentication: PAM Reset Faillock env" {
  run cp -p /etc/security/access.conf.pretest /etc/security/access.conf
}

# Return PAM environment to normal
@test "Authentication: PAM Reset PAM Test env" {
  run cp -p /etc/login.defs.pretest /etc/login.defs
  run userdel localtest1
  run userdel localtest2
  run echo "" > /etc/security/opasswd
}

# Verify PASS_MAX_DAYS reset to 90
@test "Authentication: Verify PASS_MAX_DAYS reset" {
  run grep -e "^PASS_MAX_DAYS.*90" /etc/login.defs
  [ $status -eq 0 ]
}

# Verify PASS_MIN_DAYS reset to 1
@test "Authentication: Verify PASS_MIN_DAYS reset" {
  run grep -e "^PASS_MIN_DAYS.*1" /etc/login.defs
  [ $status -eq 0 ]
}

# Verify PASS_MIN_LEN reset to 11
@test "Authentication: Verify PASS_MIN_LEN reset" {
  run grep -e "^PASS_MIN_LEN.*11" /etc/login.defs
  [ $status -eq 0 ]
}

# Verify PASS_WARN_AGE reset to 14
@test "Authentication: Verify PASS_WARN_AGE reset" {
  run grep -e "^PASS_WARN_AGE.*14" /etc/login.defs
  [ $status -eq 0 ]
}

