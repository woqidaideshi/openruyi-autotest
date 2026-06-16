#!/bin/sh -eux
# Functional test: openssh - Key-with-passphrase

. "../setup.sh"

echo "=== Test 4: Key with passphrase ==="
rlRun 'ssh-keygen -t ed25519 -f test_pass -N "testpass" -q' 0 "Generate key with passphrase"
rlRun 'ssh-keygen -p -P "testpass" -N "" -f test_pass -q' 0 "Remove passphrase"

. "../teardown.sh"
echo "All openssh Key-with-passphrase tests passed!"
