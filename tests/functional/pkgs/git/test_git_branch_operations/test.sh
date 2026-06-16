#!/bin/sh -eux
# Functional test: git - Branch-operations

. "../setup.sh"

echo "=== Test 4: Branch operations ==="
rlRun 'git branch feature' 0 "git branch: create branch"
rlRun 'git branch' 0 "git branch: list branches"
rlRun 'git branch -a' 0 "git branch -a: all branches"
rlRun 'git switch feature' 0 "git switch: switch branch"
rlRun 'git switch -' 0 "git switch -: previous branch"
rlRun 'git branch -d feature' 0 "git branch -d: delete branch"

. "../teardown.sh"
echo "All git Branch-operations tests passed!"
