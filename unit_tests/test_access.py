import os, pytest
import re

# Set test vars from environment vars
authType = os.environ["AUTH_TYPE"]


@pytest.mark.skipif(authType == 'IPA', reason="Access rules not applicable for IPA")
class TestAccess:
    # Test that the default deny all access rule is present
    def test_DenyAll(self):
        exists = 0
        pattern = re.compile("\-\s*:\s*ALL\s*:\s*ALL")
        with open('/etc/security/access.conf', 'r') as accessFile:
            for line in accessFile:
                print line.rstrip()
                if pattern.match(line):
                    exists = 1

        assert exists == 1, "Access rule to deny all is missing"


    # Test that the access rule for the gdm user is present
    def test_AllowGdm(self):
        exists = 0
        pattern = re.compile("\+\s*:\s*gdm\s*:\s*ALL")
        with open('/etc/security/access.conf', 'r') as accessFile:
            for line in accessFile:
                print line.rstrip()
                if pattern.match(line):
                    exists = 1

        assert exists == 1, "Access rule for gdm user is missing"


    # Test the the access rule for local users is present
    def test_AllowLocal(self):
        exists = 0
        pattern = re.compile("\+\s*:\s*ALL\s*:\s*LOCAL")
        with open('/etc/security/access.conf', 'r') as accessFile:
            for line in accessFile:
                print line.rstrip()
                if pattern.match(line):
                    exists = 1

        assert exists == 1, "Access rule for local users is missing"


    # Test that the access rule for the UPS (net)group is present
    def test_AllowGroup(self):
        exists = 0
        pattern = re.compile("\+\s*:\s*@role-unix-support\s*:\s*ALL")
        with open('/etc/security/access.conf', 'r') as accessFile:
            for line in accessFile:
                print line.rstrip()
                if pattern.match(line):
                    exists = 1

        assert exists == 1, "Access rule for UPS group is missing"

