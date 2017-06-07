import helpers


# Test for the existence of /home partition
def test_mountHome():
    # Run our pre-canned function to check mountpoints
    isMounted = helpers.check_mountpoint('/home')
    assert isMounted == True, "mountpoint /home does not exist"


# Test for the existence of /tmp partition
def test_mountTmp():
    # Run our pre-canned function to check mountpoints
    isMounted = helpers.check_mountpoint('/tmp')
    assert isMounted == True, "mountpoint /tmp does not exist"


# Test for the existence of /var partition
def test_mountVar():
    # Run our pre-canned function to check mountpoints
    isMounted = helpers.check_mountpoint('/var')
    assert isMounted == True, "mountpoint /var does not exist"


# Test for the existence of /var/log partition
def test_mountLog():
    # Run our pre-canned function to check mountpoints
    isMounted = helpers.check_mountpoint('/var/log')
    assert isMounted == True, "mountpoint /var/log does not exist"


# Test for the existence of /var/log/audit partition
def test_mountAudit():
    # Run our pre-canned function to check mountpoints
    isMounted = helpers.check_mountpoint('/var/log/audit')
    assert isMounted == True, "mountpoint /var/log/audit does not exist"

