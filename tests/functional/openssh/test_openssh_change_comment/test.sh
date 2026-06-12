#!/bin/sh -eux
# Functional test: openssh - Change-comment

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q openssh 2>/dev/null || { echo 'openssh not installed, skipping'; exit 0; }
which ssh-keygen 2>/dev/null || echo 'ssh-keygen not found'
rlRun 'ssh-keygen -?' 0 "ssh-keygen help"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 8: Change comment ==="
rlRun 'ssh-keygen -c -C "new_comment" -f test_comment -P ""' 0 "Change key comment"


echo ""
echo "All openssh Change-comment tests passed!"
