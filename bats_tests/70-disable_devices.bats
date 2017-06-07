#!/usr/bin/env bats
## Tests for removable devices, bluetooth, dma, uncommon filesystems and protocols

@test "ISM Removable: USB Storage Module is NOT Loaded" {
  run bash -c "lsmod | grep usb-storage"
  [ $status -ne 0 ]
}

@test "ISM Removable: sr_mod Module is NOT Loaded" {
  run bash -c "lsmod | grep sr_mod"
  [ $status -ne 0 ]
}

@test "ISM Removable: cdrom Module is NOT Loaded" {
  run bash -c "lsmod | grep cdrom"
  [ $status -ne 0 ]
}

@test "ISM Removable: Floppy Module is NOT Loaded" {
  run bash -c "lsmod | grep floppy"
  [ $status -ne 0 ]
}

@test "ISM Removable: Bluetooth Module is NOT Loaded" {
  run bash -c "lsmod | grep bluetooth"
  [ $status -ne 0 ]
}

@test "ISM Removable: net-pf-31 Module is NOT Loaded" {
  run bash -c "lsmod | grep net-pf-31"
  [ $status -ne 0 ]
}

@test "ISM External DMA: firewire-core Module is NOT Loaded" {
  run bash -c "lsmod | grep firewire-core"
  [ $status -ne 0 ]
}

@test "ISM External DMA: firewire-net Module is NOT Loaded" {
  run bash -c "lsmod | grep firewire-net"
  [ $status -ne 0 ]
}

@test "ISM External DMA: firewire-sbp2 Module is NOT Loaded" {
  run bash -c "lsmod | grep firewire-sbp2"
  [ $status -ne 0 ]
}

@test "ISM External DMA: firewire-ohci Module is NOT Loaded" {
  run bash -c "lsmod | grep firewire-ohci"
  [ $status -ne 0 ]
}

@test "ISM External DMA: ohci1394 Module is NOT Loaded" {
  run bash -c "lsmod | grep ohci1394"
  [ $status -ne 0 ]
}

@test "ISM External DMA: sbp2 Module is NOT Loaded" {
  run bash -c "lsmod | grep sbp2"
  [ $status -ne 0 ]
}

@test "ISM External DMA: dv1394 Module is NOT Loaded" {
  run bash -c "lsmod | grep dv1394"
  [ $status -ne 0 ]
}

@test "ISM External DMA: raw1394 Module is NOT Loaded" {
  run bash -c "lsmod | grep raw1394"
  [ $status -ne 0 ]
}

@test "ISM External DMA: video1394 Module is NOT Loaded" {
  run bash -c "lsmod | grep video1394"
  [ $status -ne 0 ]
}

@test "ISM Uncommon Filesystem: cramfs Module is NOT Loaded" {
  run bash -c "lsmod | grep cramfs"
  [ $status -ne 0 ]
}

@test "ISM Uncommon Filesystem: freevxfs Module is NOT Loaded" {
  run bash -c "lsmod | grep freevxfs"
  [ $status -ne 0 ]
}

@test "ISM Uncommon Filesystem: jffs2 Module is NOT Loaded" {
  run bash -c "lsmod | grep jffs2"
  [ $status -ne 0 ]
}

@test "ISM Uncommon Filesystem: hfs Module is NOT Loaded" {
  run bash -c "lsmod | grep hfs"
  [ $status -ne 0 ]
}

@test "ISM Uncommon Filesystem: hfsplus Module is NOT Loaded" {
  run bash -c "lsmod | grep hfsplus"
  [ $status -ne 0 ]
}

@test "ISM Uncommon Filesystem: squashfs Module is NOT Loaded" {
  run bash -c "lsmod | grep squashfs"
  [ $status -ne 0 ]
}

@test "ISM Uncommon Filesystem: udf Module is NOT Loaded" {
  run bash -c "lsmod | grep udf"
  [ $status -ne 0 ]
}

@test "ISM Uncommon Protocol: dccp Module is NOT Loaded" {
  run bash -c "lsmod | grep dccp"
  [ $status -ne 0 ]
}

@test "ISM Uncommon Protocol: dccp_ipv4 Module is NOT Loaded" {
  run bash -c "lsmod | grep dccp_ipv4"
  [ $status -ne 0 ]
}

@test "ISM Uncommon Protocol: dccp_ipv6 Module is NOT Loaded" {
  run bash -c "lsmod | grep dccp_ipv6"
  [ $status -ne 0 ]
}

@test "ISM Uncommon Protocol: sctp Module is NOT Loaded" {
  run bash -c "lsmod | grep sctp"
  [ $status -ne 0 ]
}

@test "ISM Uncommon Protocol: rds Module is NOT Loaded" {
  run bash -c "lsmod | grep rds"
  [ $status -ne 0 ]
}

@test "ISM Uncommon Protocol: tipc Module is NOT Loaded" {
  run bash -c "lsmod | grep tipc"
  [ $status -ne 0 ]
}

@test "ISM Uncommon Protocol: ieee1394 Module is NOT Loaded" {
  run bash -c "lsmod | grep ieee1394"
  [ $status -ne 0 ]
}
