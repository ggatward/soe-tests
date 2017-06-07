import os, pytest
import helpers
from os import stat
from pwd import getpwuid

# Read in the type of homedir to test against from system env vars
homedirType = os.environ["HOMEDIRS"]


# Tests that only run on LOCAL homedir configurations
@pytest.mark.skipif(homedirType == 'AUTOFS', reason="Automount NFS homedirs are in use")
class TestLocalHomes:
    # Verify that the oddjbod service is running
    def test_oddjobService(self):
        isRunning = helpers.check_service_status('oddjobd')
        assert isRunning == True, "oddjobd service is not running"


    # Verify that the oddjob entries exist in the PAM files
    def test_oddjobPam(self):
        exists = 0
        with open('/etc/pam.d/system-auth-ac', 'r') as pamFile:
            for line in pamFile:
                print line.rstrip()
                if 'oddjob' in line:
                    exists = 1

        assert exists == 1, "oddjob PAM entries missing"


    # Verify oddjob creates home direcotries
    def test_oddjobCreate(self):
        # Switch to the test user - should create new homedir
        os.system("su -c 'logout' - geoff")
        # Verify the homedir was created
        dirExists = os.path.exists('/home/geoff')
        assert dirExists == True, "oddjob did not create home directory"


    # Verify the correct ownership of automounted home dir
    def test_oddjobPerms(self):
        owner = getpwuid(stat('/home/geoff').st_uid).pw_name
        assert owner == 'geoff', "Incorrect owner for auto-created homedir" 




# Tests that only run on AUTOFS homedir configurations
@pytest.mark.skipif(homedirType == 'LOCAL', reason="Local homedirs are in use")
class TestAutoHomes:
    # Verify that the autofs service is running
    def test_autofsService(self):
        isRunning = helpers.check_service_status('autofs')
        assert isRunning == True, "autofs service is not running"


    # Verify homedir successfully automounts
    def test_autofsMount(self):
        # Touch the user homedir to force an automount 
        os.listdir('/home/geoff')
        # Run our pre-canned function to check mountpoints
        isMounted = helpers.check_mountpoint('/home/geoff')
        assert isMounted == True, "Mount not active"


    # Verify the correct ownership of automounted home dir
    def test_autofsPerms(self):
        owner = getpwuid(stat('/home/geoff').st_uid).pw_name
        assert owner == 'geoff', "Incorrect owner for automounted homedir" 


    # Check that the Domain in the idmapd.conf is correct for NFSv4 operation
    def test_autofsNFSv4(self):
        exists = 0
        with open('/etc/idmapd.conf', 'r') as idmapFile:
            for line in idmapFile:
                print line.rstrip()
                if line.startswith('Domain = idm.home.gatwards.org'):
                    exists = 1
                    break

        assert exists == 1, "NFSv4 idmap domain is incorrect"

