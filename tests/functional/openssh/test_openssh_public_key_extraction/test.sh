#!/bin/sh -eux
# Functional test: openssh - Public-key-extraction

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q openssh 2>/dev/null || { echo 'openssh not installed, skipping'; exit 0; }
which ssh-keygen 2>/dev/null || echo 'ssh-keygen not found'
rlRun 'ssh-keygen -?' 0 "ssh-keygen help"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 7: Public key extraction ==="
rlRun 'ssh-keygen -y -f test_ed25519 -P ""' 0 "Extract public key from private"


echo ""
echo "All openssh Public-key-extraction tests passed!"
