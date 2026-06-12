#!/bin/sh -eux
# Functional test: openssh-clients - ssh-agent

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
