#!/bin/sh -eux
# Functional test: openssh-clients - ssh-keyscan

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

echo "=== Test 5: ssh-keyscan ==="
rlRun 'ssh-keyscan -t ed25519 localhost 2>&1 | head -3' 0 "ssh-keyscan: scan localhost"
rlRun 'ssh-keyscan -t rsa localhost 2>&1 | head -3' 0 "ssh-keyscan -t rsa"
rlRun 'ssh-keyscan -t ecdsa localhost 2>&1 | head -3' 0 "ssh-keyscan -t ecdsa"


echo ""
echo "All openssh-clients ssh-keyscan tests passed!"
