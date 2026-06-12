#!/bin/sh -eux
# Functional test: openssh - RSA-key-options

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q openssh 2>/dev/null || { echo 'openssh not installed, skipping'; exit 0; }
which ssh-keygen 2>/dev/null || echo 'ssh-keygen not found'
rlRun 'ssh-keygen -?' 0 "ssh-keygen help"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 11: RSA key options ==="
rlRun 'ssh-keygen -t rsa -b 2048 -f test_rsa2048 -N "" -q' 0 "Generate RSA 2048 key"
rlRun 'ssh-keygen -l -f test_rsa2048.pub' 0 "Verify RSA 2048 key"


echo ""
echo "All openssh RSA-key-options tests passed!"
