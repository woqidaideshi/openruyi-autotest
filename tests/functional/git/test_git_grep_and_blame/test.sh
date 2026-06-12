#!/bin/sh -eux
# Functional test: git - grep-and-blame

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q git-core 2>/dev/null || { echo 'git-core not installed, skipping'; exit 0; }
which git 2>/dev/null || echo 'git not found'
rlRun 'git --version' 0 "git version"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 11: grep and blame ==="
rlRun 'git grep "content" 2>&1' 0 "git grep: search"
rlRun 'git blame file1.txt 2>&1' 0 "git blame: annotate"


echo ""
echo "All git grep-and-blame tests passed!"
