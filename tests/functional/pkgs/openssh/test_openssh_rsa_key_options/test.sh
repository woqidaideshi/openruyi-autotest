#!/bin/sh -eux
# Functional test: openssh - RSA-key-options

. "../setup.sh"

echo "=== Test 11: RSA key options ==="
rlRun 'ssh-keygen -t rsa -b 2048 -f test_rsa2048 -N "" -q' 0 "Generate RSA 2048 key"
rlRun 'ssh-keygen -l -f test_rsa2048.pub' 0 "Verify RSA 2048 key"

. "../teardown.sh"
echo "All openssh RSA-key-options tests passed!"
