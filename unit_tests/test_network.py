import os, pytest
 
def test_ping():
    hostname = "router.core.home.gatwards.org"
    response = os.system("ping -c 1 " + hostname)
    assert response == 0, "Cannot ping gateway"


def test_dns():
    hostname = "ntp1.core.home.gatwards.org"
    response = os.system("nslookup " + hostname)
    assert response == 0, "Cannot resolve DNS entries"

