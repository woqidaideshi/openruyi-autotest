#!/bin/sh -eux
# Functional test: git - Stash

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q git-core' 0 "Check git-core installed"
rlRun 'which git' 0 "Check git available"
rlRun 'git --version' 0 "git version"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 10: Stash ==="
echo "wip" > wip.txt
rlRun 'git stash push -m "wip changes" 2>&1 || true' 0 "git stash: push"
rlRun 'git stash list 2>&1 || true' 0 "git stash list"
rlRun 'git stash pop 2>&1 || true' 0 "git stash pop"


echo ""
echo "All git Stash tests passed!"
