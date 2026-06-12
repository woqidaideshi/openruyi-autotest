#!/bin/sh -eux
# Functional test: openssh-clients - ssh-keygen-via-openssh

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

echo "=== Test 3: ssh-keygen via openssh ==="
rlRun 'ssh-keygen -t ed25519 -f test_key -N "" -q' 0 "Generate test key"


echo ""
echo "All openssh-clients ssh-keygen-via-openssh tests passed!"
