#!/bin/sh -eux
# Functional test: openssh - Key-with-passphrase

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q openssh' 0 "Check openssh is installed"
rlRun 'which ssh-keygen' 0 "Check ssh-keygen available"
rlRun 'ssh-keygen -?' 0 "ssh-keygen help"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 4: Key with passphrase ==="
rlRun 'ssh-keygen -t ed25519 -f test_pass -N "testpass" -q' 0 "Generate key with passphrase"
rlRun 'ssh-keygen -p -P "testpass" -N "" -f test_pass -q' 0 "Remove passphrase"


echo ""
echo "All openssh Key-with-passphrase tests passed!"
