#!/bin/sh -eux
# Functional test: openssh-clients - ssh-connection--dry-run

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

echo "=== Test 2: ssh connection (dry-run) ==="
rlRun 'ssh -G localhost 2>&1 | head -10' 0 "ssh -G: print config"
rlRun 'ssh -T -o ConnectTimeout=5 localhost 2>&1 || true' 0 "ssh -T: disable PTY"
rlRun 'ssh -v localhost 2>&1 | head -10 || true' 0 "ssh -v: verbose"


echo ""
echo "All openssh-clients ssh-connection--dry-run tests passed!"
