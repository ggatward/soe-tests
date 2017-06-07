import os
import commands
import psutil


def check_service_status(service_name):
    status = os.system('service ' +service_name+ ' status > /dev/null')
    print os.system('service ' +service_name+ ' status')
    if status == 0:
        isRunning = True 
    else:
        isRunning = False
    return isRunning


def check_mountpoint(mountname):
    partitions = psutil.disk_partitions(all=True)
    # Loop through all partitions looking for 'mountname'
    for p in partitions:
        print p  
        if mountname in p.mountpoint:
            mountFound = True
            break
        else:
            mountFound = False
    return mountFound


