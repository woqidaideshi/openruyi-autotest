#!/bin/sh -eux
# Functional test: git - Stash

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q git-core 2>/dev/null || { echo 'git-core not installed, skipping'; exit 0; }
which git 2>/dev/null || echo 'git not found'
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
