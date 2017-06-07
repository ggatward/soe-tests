#!/usr/bin/env bats

load setup-test-environment

@test "VM tools: Correct tools package is installed" {
  if [ "$(virt-what)" == "vmware" ]; then
    run bash -c "rpm -q open-vm-tools"
    [ $status -eq 0 ]
  elif [ "$(virt-what)" == "kvm" ]; then
    # Test if we look like a RHEV guest
    if [ -f /dev/virtio-ports/com.redhat.rhevm.vdsm ]; then
      run bash -c "rpm -q rhevm-guest-agent-common"
      [ $status -eq 0 ]
    fi
  elif [ "$(virt-what)" == "" ]; then
    skip "VM tools are not required on physical hosts"
  fi
}

@test "VM tools: Agent is running" {
  if [ "$(virt-what)" == "vmware" ]; then
    if [ $rel -ge 7 ]; then
      run bash -c "systemctl status vmtoolsd.service"
      [ $status -eq 0 ]
    else
      run bash -c "service vmtoolsd status"
      [ $status -eq 0 ]
    fi
  elif [ "$(virt-what)" == "kvm" ]; then
    # Test if we look like a RHEV guest
    if [ -f /dev/virtio-ports/com.redhat.rhevm.vdsm ]; then
      if [ $rel -ge 7 ]; then
        run bash -c "systemctl status ovirt-guest-agent.service"
        [ $status -eq 0 ]
      else
        run bash -c "service ovirt-guest-agent status"
        [ $status -eq 0 ]
      fi
    fi
  fi
}

@test "VM tools: vmtoolsd does not contain pam_unix2.so binary module" {
  if [ "$(virt-what)" == "vmware" ]; then
    run bash -c 'grep "pam_unix2\.so" /etc/pam.d/vmtoolsd'
    [ $status -ne 0 ]
  fi
}
