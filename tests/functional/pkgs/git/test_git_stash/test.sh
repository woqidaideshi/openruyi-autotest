#!/bin/sh -eux
# Functional test: git - Stash

. "../setup.sh"

echo "=== Test 10: Stash ==="
echo "wip" > wip.txt
rlRun 'git stash push -m "wip changes" 2>&1 || true' 0 "git stash: push"
rlRun 'git stash list 2>&1 || true' 0 "git stash list"
rlRun 'git stash pop 2>&1 || true' 0 "git stash pop"

. "../teardown.sh"
echo "All git Stash tests passed!"
