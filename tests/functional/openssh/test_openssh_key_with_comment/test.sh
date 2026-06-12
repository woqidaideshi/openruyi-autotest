#!/bin/sh -eux
# Functional test: openssh - Key-with-comment

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q openssh' 0 "Check openssh is installed"
rlRun 'which ssh-keygen' 0 "Check ssh-keygen available"
rlRun 'ssh-keygen -?' 0 "ssh-keygen help"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 5: Key with comment ==="
rlRun 'ssh-keygen -t ed25519 -f test_comment -C "test@example.com" -N "" -q' 0 "Generate key with comment"
rlRun 'grep -q "test@example.com" test_comment.pub' 0 "Verify comment in pubkey"


echo ""
echo "All openssh Key-with-comment tests passed!"
