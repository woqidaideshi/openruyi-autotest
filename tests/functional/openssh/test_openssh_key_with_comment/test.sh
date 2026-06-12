#!/bin/sh -eux
# Functional test: openssh - Key-with-comment

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q openssh 2>/dev/null || { echo 'openssh not installed, skipping'; exit 0; }
which ssh-keygen 2>/dev/null || echo 'ssh-keygen not found'
rlRun 'ssh-keygen -?' 0 "ssh-keygen help"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 5: Key with comment ==="
rlRun 'ssh-keygen -t ed25519 -f test_comment -C "test@example.com" -N "" -q' 0 "Generate key with comment"
rlRun 'grep -q "test@example.com" test_comment.pub' 0 "Verify comment in pubkey"


echo ""
echo "All openssh Key-with-comment tests passed!"
