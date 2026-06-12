#!/bin/sh -eux
# Functional test: openssh - RSA-key-options

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q openssh' 0 "Check openssh is installed"
rlRun 'which ssh-keygen' 0 "Check ssh-keygen available"
rlRun 'ssh-keygen -?' 0 "ssh-keygen help"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 11: RSA key options ==="
rlRun 'ssh-keygen -t rsa -b 2048 -f test_rsa2048 -N "" -q' 0 "Generate RSA 2048 key"
rlRun 'ssh-keygen -l -f test_rsa2048.pub' 0 "Verify RSA 2048 key"


echo ""
echo "All openssh RSA-key-options tests passed!"
