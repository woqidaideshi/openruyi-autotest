#!/bin/sh -eux
# Functional test: openssh - Change-comment

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q openssh' 0 "Check openssh is installed"
rlRun 'which ssh-keygen' 0 "Check ssh-keygen available"
rlRun 'ssh-keygen -?' 0 "ssh-keygen help"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 8: Change comment ==="
rlRun 'ssh-keygen -c -C "new_comment" -f test_comment -P ""' 0 "Change key comment"


echo ""
echo "All openssh Change-comment tests passed!"
