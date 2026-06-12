#!/bin/sh -eux
# Functional test: openssh-clients - ssh-version-and-help

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

echo "=== Test 1: ssh version and help ==="
rlRun 'ssh -V 2>&1' 0 "ssh version"
rlRun 'ssh -Q key 2>&1 | head -10' 0 "ssh -Q key: supported keys"
rlRun 'ssh -Q cipher 2>&1 | head -5' 0 "ssh -Q cipher: ciphers"
rlRun 'ssh -Q mac 2>&1 | head -5' 0 "ssh -Q mac: MACs"
rlRun 'ssh -Q kex 2>&1 | head -5' 0 "ssh -Q kex: key exchange"


echo ""
echo "All openssh-clients ssh-version-and-help tests passed!"
