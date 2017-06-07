import os, pytest


# Set test vars from environment vars
authType = os.environ["AUTH_TYPE"]


# Test that the 'wheel' group does not have sudo access
def test_WheelNotAllowed():
    exists = 0
#    with open('/etc/sudoers', 'r') as sudoFile:
    with open('/tmp/sudoers', 'r') as sudoFile:
        for line in sudoFile:
            print line.rstrip()
            if line.startswith('%wheel'):
                exists = 1
    
    # We expect that the result is 0, otherwise raise the error
    assert exists == 0, "'wheel' group has sudo rights" 


# Tests that only run on posix LDAP configurations
@pytest.mark.skipif(authType != 'POSIX', reason="Authentication method is not POSIX LDAP")
def test_UnixTeamNetgroup():
    with open('/tmp/sudoers.d/role-unix-support', 'r') as sudoFile:
        for line in sudoFile:
            print line.rstrip()
            if line.startswith('+role-unix-support'):
                exists = 1

    assert exists == 0, "Unix team Sudo entry error"


# Tests that only run on AD configurations
@pytest.mark.skipif(authType != 'AD', reason="Authentication method is not AD")
def test_UnixTeamGroup():
    with open('/tmp/sudoers.d/role-unix-support', 'r') as sudoFile:
        for line in sudoFile:
            print line.rstrip()
            if line.startswith('@unix-support'):
                exists = 1

    assert exists == 0, "Unix team Sudo entry error"


