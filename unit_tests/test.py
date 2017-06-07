import re


exists = 0
pattern = re.compile("\+\s*:\s*@role-unix-support\s*:\s*ALL")
with open('/etc/security/access.conf', 'r') as accessFile:
    for line in accessFile:
        print line.rstrip()
        if pattern.match(line):
            exists = 1

    print exists
