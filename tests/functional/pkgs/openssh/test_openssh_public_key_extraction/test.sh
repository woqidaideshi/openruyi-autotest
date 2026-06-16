#!/bin/sh -eux
# Functional test: openssh - Public-key-extraction

. "../setup.sh"

echo "=== Test 7: Public key extraction ==="
rlRun 'ssh-keygen -y -f test_ed25519 -P ""' 0 "Extract public key from private"

. "../teardown.sh"
echo "All openssh Public-key-extraction tests passed!"
