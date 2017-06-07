#!/usr/bin/env bats

#This test will validate if a yum update can be performed without error
#We check the install.post.log that it does not contain skip-broken which is a symptom of broken pkgs
@test "ISM patching: yum update command ran" {
  run bash -c "grep skip-broken /root/install.post.log"
  [ $status -ne 0 ]
}

# Check yum-cron is running
@test "ISM patching: yum-cron is running" {
  run bash -c "./checkservices.bash yum-cron"
  [ $status -eq 0 ]
}

#Test if the /usr/sbin/yum_update_schedule script is in place
@test "ISM patching - Scheduled: yum_update_schedule script is in place" {
  run bash -c "ls /usr/sbin/yum_update_schedule"
  [ $status -eq 0 ]
}

#Use rel variable
rel=$(cat /etc/redhat-release | awk '{ print int($7)}')
#Test if there is a configuration file for yum-cron
@test "ISM patching - Scheduled: yum-cron configuration file is in place" {
  if [ ${rel} -ge 7 ];
  then
    run bash -c "ls /etc/yum/yum-cron.conf"
  else
    run bash -c "ls /etc/sysconfig/yum-cron"
  fi
  [ $status -eq 0 ]
}

#Test if there is a /etc/cron.d/0yumupdateschedule in place
@test "ISM patching - Scheduled: cron.d schedule is in place" {
  run bash -c "ls /etc/cron.d/0yumupdateschedule"
  [ $status -eq 0 ]
}
