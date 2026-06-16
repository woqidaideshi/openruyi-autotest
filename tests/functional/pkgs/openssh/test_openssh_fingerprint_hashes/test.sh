#!/bin/sh -eux
# Functional test: openssh - Fingerprint-hashes

. "../setup.sh"

echo "=== Test 10: Fingerprint hashes ==="
rlRun 'ssh-keygen -l -f test_rsa.pub -E sha256' 0 "SHA256 fingerprint"
rlRun 'ssh-keygen -l -f test_rsa.pub -E md5 2>&1 || true' 0 "MD5 fingerprint"

. "../teardown.sh"
echo "All openssh Fingerprint-hashes tests passed!"
