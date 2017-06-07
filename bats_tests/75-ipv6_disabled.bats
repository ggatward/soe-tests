#!/usr/bin/env bats
#
# Check that IPv6 kernel modules are loaded and set to correct default values.
# Check that IPv6 has been disabled on external network interface.
# Check that IPv6 has been disabled on the local loopback interface.


ETH_INF=`ls -1 /sys/class/net | grep -v lo`
export ETH_INF

@test "ISM IPv6: kernel variable net.ipv6.conf.all.disable_ipv6 = 1" {
  run bash -c "/sbin/sysctl net.ipv6.conf.all.disable_ipv6"
  [[ ${lines[0]} =~ " = 1" ]]
}


@test "ISM IPv6: kernel variable net.ipv6.conf.default.disable_ipv6 = 1" {
  run bash -c "/sbin/sysctl net.ipv6.conf.default.disable_ipv6"
  [[ ${lines[0]} =~ " = 1" ]]
}


@test "ISM IPv6: kernel variable net.ipv6.conf.${ETH_INF}.disable_ipv6 = 1" {
  run bash -c "/sbin/sysctl net.ipv6.conf.${ETH_INF}.disable_ipv6"
  [[ ${lines[0]} =~ " = 1" ]]
}


@test "ISM IPv6: kernel variable net.ipv6.conf.lo.disable_ipv6 = 1" {
  run bash -c "/sbin/sysctl net.ipv6.conf.lo.disable_ipv6"
  [[ ${lines[0]} =~ " = 1" ]]
}


@test "ISM IPv6: disabled on external network interface" {
  run bash -c "/sbin/ip addr show eth0 | grep inet6"
  [ ${status} -eq 1 ]
}


@test "ISM IPv6: disabled on local loopback interface" {
  run bash -c "/sbin/ip addr show lo | grep inet6"
  [ ${status} -eq 1 ]
}
