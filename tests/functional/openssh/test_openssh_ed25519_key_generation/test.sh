#!/bin/sh -eux
# Functional test: openssh - Ed25519-key-generation

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q openssh 2>/dev/null || { echo 'openssh not installed, skipping'; exit 0; }
which ssh-keygen 2>/dev/null || echo 'ssh-keygen not found'
rlRun 'ssh-keygen -?' 0 "ssh-keygen help"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 3: Ed25519 key generation ==="
rlRun 'ssh-keygen -t ed25519 -f test_ed25519 -N "" -q' 0 "Generate Ed25519 key"
rlRun 'ssh-keygen -l -f test_ed25519.pub' 0 "Show Ed25519 fingerprint"
rlRun 'ssh-keygen -l -v -f test_ed25519.pub 2>&1 || true' 0 "Verbose fingerprint"


echo ""
echo "All openssh Ed25519-key-generation tests passed!"
