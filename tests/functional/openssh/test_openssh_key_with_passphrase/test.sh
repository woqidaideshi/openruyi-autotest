#!/bin/sh -eux
# Functional test: openssh - Key-with-passphrase

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q openssh 2>/dev/null || { echo 'openssh not installed, skipping'; exit 0; }
which ssh-keygen 2>/dev/null || echo 'ssh-keygen not found'
rlRun 'ssh-keygen -?' 0 "ssh-keygen help"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 4: Key with passphrase ==="
rlRun 'ssh-keygen -t ed25519 -f test_pass -N "testpass" -q' 0 "Generate key with passphrase"
rlRun 'ssh-keygen -p -P "testpass" -N "" -f test_pass -q' 0 "Remove passphrase"


echo ""
echo "All openssh Key-with-passphrase tests passed!"
