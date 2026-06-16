#!/bin/sh -eux
# Functional test: openssh - Change-comment

. "../setup.sh"

echo "=== Test 8: Change comment ==="
rlRun 'ssh-keygen -c -C "new_comment" -f test_comment -P ""' 0 "Change key comment"

. "../teardown.sh"
echo "All openssh Change-comment tests passed!"
