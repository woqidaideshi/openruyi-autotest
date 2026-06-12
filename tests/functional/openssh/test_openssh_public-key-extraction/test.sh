#!/bin/sh -eux
# Functional test: openssh - Public-key-extraction

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q openssh' 0 "Check openssh is installed"
rlRun 'which ssh-keygen' 0 "Check ssh-keygen available"
rlRun 'ssh-keygen -?' 0 "ssh-keygen help"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 7: Public key extraction ==="
rlRun 'ssh-keygen -y -f test_ed25519 -P ""' 0 "Extract public key from private"


echo ""
echo "All openssh Public-key-extraction tests passed!"
