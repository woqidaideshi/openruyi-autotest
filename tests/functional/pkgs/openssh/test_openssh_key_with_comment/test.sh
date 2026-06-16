#!/bin/sh -eux
# Functional test: openssh - Key-with-comment

. "../setup.sh"

echo "=== Test 5: Key with comment ==="
rlRun 'ssh-keygen -t ed25519 -f test_comment -C "test@example.com" -N "" -q' 0 "Generate key with comment"
rlRun 'grep -q "test@example.com" test_comment.pub' 0 "Verify comment in pubkey"

. "../teardown.sh"
echo "All openssh Key-with-comment tests passed!"
