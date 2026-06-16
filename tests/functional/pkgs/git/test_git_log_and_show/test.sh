#!/bin/sh -eux
# Functional test: git - Log-and-show

. "../setup.sh"

echo "=== Test 6: Log and show ==="
rlRun 'git log --oneline -3' 0 "git log: last 3 commits"
rlRun 'git log --graph --oneline' 0 "git log --graph"
rlRun 'git show HEAD --stat' 0 "git show: latest commit"
rlRun 'git show HEAD~1 --oneline' 0 "git show: previous commit"

. "../teardown.sh"
echo "All git Log-and-show tests passed!"
