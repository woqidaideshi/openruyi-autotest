#!/bin/sh -eux
# Functional test: openssh - RSA-key-generation

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q openssh' 0 "Check openssh is installed"
rlRun 'which ssh-keygen' 0 "Check ssh-keygen available"
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
