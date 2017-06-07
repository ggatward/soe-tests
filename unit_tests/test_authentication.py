import os, pytest
import pwd, grp

# Set test variables from environment vars
authType = os.environ["AUTH_TYPE"]


# Class to test auth source lookups (getent)
class TestLookups:
    # Test that the specified user exists
    def test_lookupUser(self):
        try:
            result = pwd.getpwnam('geoff')
            if result:
                print result
                exists = 1
        except KeyError:
            exists = 0

        assert exists == 1, "User lookup failed"


    # Test that the specified group exists
    def test_lookupGroup(self):
        try:
            result = grp.getgrnam('family')
            if result:
                print result
                exists = 1
        except KeyError:
            exists = 0

        assert exists == 1, "Group lookup failed"


    # Test specified netgroup exists, but only if netgroups apply.
    @pytest.mark.skipif(authType == 'AD', reason="Netgroups not applicable in AD")
    def test_lookupNetgroup(self):
        assert 0 == 1, "Netgroup lookup failed"



