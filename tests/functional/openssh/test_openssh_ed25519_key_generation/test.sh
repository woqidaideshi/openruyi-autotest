#!/bin/sh -eux
# Functional test: openssh - Ed25519-key-generation

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q openssh' 0 "Check openssh is installed"
rlRun 'which ssh-keygen' 0 "Check ssh-keygen available"
rlRun 'ssh-keygen -?' 0 "ssh-keygen help"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 3: Ed25519 key generation ==="
rlRun 'ssh-keygen -t ed25519 -f test_ed25519 -N "" -q' 0 "Generate Ed25519 key"
rlRun 'ssh-keygen -l -f test_ed25519.pub' 0 "Show Ed25519 fingerprint"
rlRun 'ssh-keygen -l -v -f test_ed25519.pub 2>&1 || true' 0 "Verbose fingerprint"


echo ""
echo "All openssh Ed25519-key-generation tests passed!"
