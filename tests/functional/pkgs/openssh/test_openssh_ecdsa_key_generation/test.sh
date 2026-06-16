#!/bin/sh -eux
# Functional test: openssh - ECDSA-key-generation

. "../setup.sh"

echo "=== Test 2: ECDSA key generation ==="
rlRun 'ssh-keygen -t ecdsa -b 256 -f test_ecdsa -N "" -q' 0 "Generate ECDSA 256 key"
rlRun 'ssh-keygen -l -f test_ecdsa.pub' 0 "Show ECDSA fingerprint"

. "../teardown.sh"
echo "All openssh ECDSA-key-generation tests passed!"
