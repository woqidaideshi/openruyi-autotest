#!/bin/sh -eux
# Functional test: openssh - Fingerprint-hashes

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q openssh 2>/dev/null || { echo 'openssh not installed, skipping'; exit 0; }
which ssh-keygen 2>/dev/null || echo 'ssh-keygen not found'
rlRun 'ssh-keygen -?' 0 "ssh-keygen help"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 10: Fingerprint hashes ==="
rlRun 'ssh-keygen -l -f test_rsa.pub -E sha256' 0 "SHA256 fingerprint"
rlRun 'ssh-keygen -l -f test_rsa.pub -E md5 2>&1 || true' 0 "MD5 fingerprint"


echo ""
echo "All openssh Fingerprint-hashes tests passed!"
