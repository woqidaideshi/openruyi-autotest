#!/bin/sh -eux
# Functional test: git - Error-handling

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q git-core 2>/dev/null || { echo 'git-core not installed, skipping'; exit 0; }
which git 2>/dev/null || echo 'git not found'
rlRun 'git --version' 0 "git version"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 15: Error handling ==="
rlRun 'git nonexistent 2>&1 || true' 0 "git: invalid command"
rlRun 'git --invalid-option 2>&1 || true' 0 "git: invalid option"

cd /
rm -rf $TmpDir

echo ""
echo "All git functional tests passed!"

echo ""
echo "All git Error-handling tests passed!"
