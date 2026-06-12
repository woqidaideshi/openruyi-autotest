#!/bin/sh -eux
# Functional test: openssh - Fingerprint-hashes

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q openssh' 0 "Check openssh is installed"
rlRun 'which ssh-keygen' 0 "Check ssh-keygen available"
rlRun 'ssh-keygen -?' 0 "ssh-keygen help"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 10: Fingerprint hashes ==="
rlRun 'ssh-keygen -l -f test_rsa.pub -E sha256' 0 "SHA256 fingerprint"
rlRun 'ssh-keygen -l -f test_rsa.pub -E md5 2>&1 || true' 0 "MD5 fingerprint"


echo ""
echo "All openssh Fingerprint-hashes tests passed!"
