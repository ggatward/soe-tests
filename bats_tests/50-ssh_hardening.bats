#!/usr/bin/env bats
# Ensure SSH (client and server) hardening is working

##### Check Host Keys ##############################################################################
# ISM references inside /etc/ssh/ssh_config
@test "ISM SSH Server: HostKey - 384 bit ECDSA host key exists" {
  # Check length and type of key
  run bash -c "ssh-keygen -lf /etc/ssh/ssh_host_ecdsa_key.pub | grep -E '384.*\(ECDSA\)'"
  [ ${status} -eq 0 ]
}

# ISM references inside /etc/ssh/ssh_config
@test "ISM SSH Server: HostKey - 3072 bit RSA host key exists" {
  # Check length and type of key
  run bash -c "ssh-keygen -lf /etc/ssh/ssh_host_rsa_key.pub | grep -E '3072.*\(RSA\)'"
  [ ${status} -eq 0 ]
}


##### Check Public Key Authentication ##############################################################
@test "ISM SSH: Public Key authentication with ECDSA keys works" {
  # Despite having an external script which includes this preparation, this particular test needs to
  # force the generation of new keys.
  if [ -f /root/.ssh/id_ecdsa ]; then
    rm -f /root/.ssh/id_ecds* > /dev/null 2>&1
  fi
  /usr/bin/ssh-keygen -q -t ecdsa -b 384 -f /root/.ssh/id_ecdsa -N ''
  cat /root/.ssh/id_ecdsa.pub >> /root/.ssh/authorized_keys

  run bash -c "./50-ssh-connectivity-test.bash"
  [ $status -eq 0 ]
}


##### Check Key Exchange Algorithms (KexAlgorithms) ################################################
@test "ISM SSH Server: KexAlgorithms - Can connect using ecdh-sha2-nistp384 Key Exchange Algorithm" {
  run bash -c "./50-ssh-connectivity-test.bash -o KexAlgorithms=ecdh-sha2-nistp384"
  [ $status -eq 0 ]
}

@test "ISM SSH Server: KexAlgorithms - Can connect using ecdh-sha2-nistp521 Key Exchange Algorithm" {
  run bash -c "./50-ssh-connectivity-test.bash -o KexAlgorithms=ecdh-sha2-nistp521"
  [ $status -eq 0 ]
}

@test "ISM SSH Server: KexAlgorithms - Can connect using diffie-hellman-group14-sha1 Key Exchange Algorithm" {
  run bash -c "./50-ssh-connectivity-test.bash -o KexAlgorithms=diffie-hellman-group14-sha1"
  [ $status -eq 0 ]
}

# Ensure weak default OpenSSH "KexAlgorithms" do not work.
@test "ISM SSH Server: KexAlgorithms - Cannot connect using diffie-hellman-group-exchange-sha256 Key Exchange Algorithm" {
  run bash -c "./50-ssh-connectivity-test.bash -o KexAlgorithms=diffie-hellman-group-exchange-sha256"
  [ $status -eq 1 ]
}

@test "ISM SSH Server: KexAlgorithms - Cannot connect using diffie-hellman-group-exchange-sha1 Key Exchange Algorithm" {
  run bash -c "./50-ssh-connectivity-test.bash -o KexAlgorithms=diffie-hellman-group-exchange-sha1"
  [ $status -eq 1 ]
}

@test "ISM SSH Server: KexAlgorithms - Cannot connect using diffie-hellman-group1-sha1 Key Exchange Algorithm" {
  run bash -c "./50-ssh-connectivity-test.bash -o KexAlgorithms=diffie-hellman-group1-sha1"
  [ $status -eq 1 ]
}


##### Check encrpytion ciphers #####################################################################
@test "ISM SSH Server: Ciphers - Can connect using aes256-ctr encryption cipher" {
  run bash -c "./50-ssh-connectivity-test.bash -c aes256-ctr"
  [ $status -eq 0 ]
}

# Ensure default weak OpenSSH "Ciphers" do not work.
## Check "man sshd_config" on RHEL 6 for the default order.
@test "ISM SSH Server: Ciphers - Cannot connect using aes192-ctr encryption cipher" {
  run bash -c "./50-ssh-connectivity-test.bash -c aes192-ctr"
  [ $status -eq 1 ]
}

@test "ISM SSH Server: Ciphers - Cannot connect using aes128-ctr encryption cipher" {
  run bash -c "./50-ssh-connectivity-test.bash -c aes128-ctr"
  [ $status -eq 1 ]
}

@test "ISM SSH Server: Ciphers - Cannot connect using aes128-cbc encryption cipher" {
  run bash -c "./50-ssh-connectivity-test.bash -c aes128-cbc"
  [ $status -eq 1 ]
}


##### Check configured "MACs" work #################################################################
# MACs = message authentication code algorithms
@test "ISM SSH Server: MACs - Can connect using hmac-sha2-512 message authentication code algorithm" {
  run bash -c "./50-ssh-connectivity-test.bash -o MACs=hmac-sha2-512"
  [ $status -eq 0 ]
}

@test "ISM SSH Server: MACs - Can connect using hmac-sha2-256 message authentication code algorithm" {
  run bash -c "./50-ssh-connectivity-test.bash -o MACs=hmac-sha2-256"
  [ $status -eq 0 ]
}

@test "ISM SSH Server: MACs - Can connect using hmac-sha1 message authentication code algorithm" {
  run bash -c "./50-ssh-connectivity-test.bash -o MACs=hmac-sha1"
  [ $status -eq 0 ]
}

# Ensure default weak "MACs" do not work. Check "man sshd_config" on RHEL 6 for the default order.
@test "ISM SSH Server: MACs - Cannot using hmac-ripemd160 message authentication code algorithm" {
  run bash -c "./50-ssh-connectivity-test.bash -o MACs=hmac-ripemd160"
  [ $status -eq 1 ]
}

@test "ISM SSH Server: MACs - Cannot connect using hmac-md5 message authentication code algorithm" {
  run bash -c "./50-ssh-connectivity-test.bash -o MACs=hmac-md5"
  [ $status -eq 1 ]
}
