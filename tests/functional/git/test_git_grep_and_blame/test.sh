#!/bin/sh -eux
# Functional test: git - grep-and-blame

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q git-core' 0 "Check git-core installed"
rlRun 'which git' 0 "Check git available"
rlRun 'git --version' 0 "git version"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 11: grep and blame ==="
rlRun 'git grep "content" 2>&1' 0 "git grep: search"
rlRun 'git blame file1.txt 2>&1' 0 "git blame: annotate"


echo ""
echo "All git grep-and-blame tests passed!"
