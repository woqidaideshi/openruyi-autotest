#!/bin/sh -eux
# Functional test: openssh-clients - ssh-keygen-via-openssh

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q openssh-clients 2>/dev/null || { echo 'openssh-clients not installed, skipping'; exit 0; }
which ssh 2>/dev/null || echo 'ssh not found'
which scp 2>/dev/null || echo 'scp not found'
which sftp 2>/dev/null || echo 'sftp not found'
which ssh-add 2>/dev/null || echo 'ssh-add not found'
which ssh-agent 2>/dev/null || echo 'ssh-agent not found'
which ssh-copy-id 2>/dev/null || echo 'ssh-copy-id not found'
which ssh-keyscan 2>/dev/null || echo 'ssh-keyscan not found'
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 3: ssh-keygen via openssh ==="
rlRun 'ssh-keygen -t ed25519 -f test_key -N "" -q' 0 "Generate test key"


echo ""
echo "All openssh-clients ssh-keygen-via-openssh tests passed!"
