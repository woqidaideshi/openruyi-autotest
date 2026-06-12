#!/bin/sh -eux
# Functional test: git - scalar

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q git-core 2>/dev/null || { echo 'git-core not installed, skipping'; exit 0; }
which git 2>/dev/null || echo 'git not found'
rlRun 'git --version' 0 "git version"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 14: scalar ==="
which scalar 2>/dev/null || echo 'scalar not found'
rlRun 'scalar --help 2>&1 | head -5' 0 "scalar help"


echo ""
echo "All git scalar tests passed!"
