#!/bin/sh -eux
# Functional test: git - Log-and-show

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q git-core 2>/dev/null || { echo 'git-core not installed, skipping'; exit 0; }
which git 2>/dev/null || echo 'git not found'
rlRun 'git --version' 0 "git version"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 6: Log and show ==="
rlRun 'git log --oneline -3' 0 "git log: last 3 commits"
rlRun 'git log --graph --oneline' 0 "git log --graph"
rlRun 'git show HEAD --stat' 0 "git show: latest commit"
rlRun 'git show HEAD~1 --oneline' 0 "git show: previous commit"


echo ""
echo "All git Log-and-show tests passed!"
