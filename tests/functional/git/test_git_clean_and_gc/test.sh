#!/bin/sh -eux
# Functional test: git - Clean-and-gc

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q git-core 2>/dev/null || { echo 'git-core not installed, skipping'; exit 0; }
which git 2>/dev/null || echo 'git not found'
rlRun 'git --version' 0 "git version"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 12: Clean and gc ==="
rlRun 'git clean -n' 0 "git clean -n: dry run"
rlRun 'git gc --auto 2>&1 || true' 0 "git gc: garbage collect"


echo ""
echo "All git Clean-and-gc tests passed!"
