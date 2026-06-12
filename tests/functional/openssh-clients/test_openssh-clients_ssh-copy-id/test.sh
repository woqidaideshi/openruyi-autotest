#!/bin/sh -eux
# Functional test: openssh-clients - ssh-copy-id

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

echo "=== Test 8: ssh-copy-id ==="
ssh-copy-id -h 2>&1 | head -3 || true
echo "ssh-copy-id done"


echo ""
echo "All openssh-clients ssh-copy-id tests passed!"
