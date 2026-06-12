#!/bin/sh -eux
# Functional test: openssh-clients - ssh-version-and-help

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q openssh-clients' 0 "Check openssh-clients installed"
rlRun 'which ssh' 0 "Check ssh available"
rlRun 'which scp' 0 "Check scp available"
rlRun 'which sftp' 0 "Check sftp available"
rlRun 'which ssh-add' 0 "Check ssh-add available"
rlRun 'which ssh-agent' 0 "Check ssh-agent available"
rlRun 'which ssh-copy-id' 0 "Check ssh-copy-id available"
rlRun 'which ssh-keyscan' 0 "Check ssh-keyscan available"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 1: ssh version and help ==="
rlRun 'ssh -V 2>&1' 0 "ssh version"
rlRun 'ssh -Q key 2>&1 | head -10' 0 "ssh -Q key: supported keys"
rlRun 'ssh -Q cipher 2>&1 | head -5' 0 "ssh -Q cipher: ciphers"
rlRun 'ssh -Q mac 2>&1 | head -5' 0 "ssh -Q mac: MACs"
rlRun 'ssh -Q kex 2>&1 | head -5' 0 "ssh -Q kex: key exchange"


echo ""
echo "All openssh-clients ssh-version-and-help tests passed!"
