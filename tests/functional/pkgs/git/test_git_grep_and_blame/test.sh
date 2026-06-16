#!/bin/sh -eux
# Functional test: git - grep-and-blame

. "../setup.sh"

echo "=== Test 11: grep and blame ==="
rlRun 'git grep "content" 2>&1' 0 "git grep: search"
rlRun 'git blame file1.txt 2>&1' 0 "git blame: annotate"

. "../teardown.sh"
echo "All git grep-and-blame tests passed!"
