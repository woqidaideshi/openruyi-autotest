#!/bin/sh -eux
# Functional test: openssh - RSA-key-generation

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q openssh 2>/dev/null || { echo 'openssh not installed, skipping'; exit 0; }
which ssh-keygen 2>/dev/null || echo 'ssh-keygen not found'
rlRun 'ssh-keygen -?' 0 "ssh-keygen help"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 1: RSA key generation ==="
rlRun 'ssh-keygen -t rsa -b 2048 -f test_rsa -N "" -q' 0 "Generate RSA 2048 key"
rlRun 'test -f test_rsa' 0 "Private key exists"
rlRun 'test -f test_rsa.pub' 0 "Public key exists"
rlRun 'ssh-keygen -l -f test_rsa' 0 "Show RSA key fingerprint"


echo ""
echo "All openssh RSA-key-generation tests passed!"
