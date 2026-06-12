#!/bin/sh -eux
# Functional test: openssh-clients - ssh-agent

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

echo "=== Test 4: ssh-agent ==="
eval $(ssh-agent -s) 2>&1 || true
rlRun 'ssh-add -l 2>&1 || true' 0 "ssh-add: list keys"
rlRun 'ssh-add test_key 2>&1' 0 "ssh-add: add key"
rlRun 'ssh-add -l 2>&1' 0 "ssh-add: verify key added"
rlRun 'ssh-add -L 2>&1' 0 "ssh-add -L: list public keys"
rlRun 'ssh-add -d test_key 2>&1' 0 "ssh-add -d: remove key"
ssh-agent -k 2>&1 || true


echo ""
echo "All openssh-clients ssh-agent tests passed!"
