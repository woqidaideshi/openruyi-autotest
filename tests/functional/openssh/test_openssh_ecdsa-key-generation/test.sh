#!/bin/sh -eux
# Functional test: openssh - ECDSA-key-generation

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q openssh' 0 "Check openssh is installed"
rlRun 'which ssh-keygen' 0 "Check ssh-keygen available"
rlRun 'ssh-keygen -?' 0 "ssh-keygen help"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 2: ECDSA key generation ==="
rlRun 'ssh-keygen -t ecdsa -b 256 -f test_ecdsa -N "" -q' 0 "Generate ECDSA 256 key"
rlRun 'ssh-keygen -l -f test_ecdsa.pub' 0 "Show ECDSA fingerprint"


echo ""
echo "All openssh ECDSA-key-generation tests passed!"
