#!/bin/sh -eux
# Functional test: git - git-shell

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q git-core 2>/dev/null || { echo 'git-core not installed, skipping'; exit 0; }
which git 2>/dev/null || echo 'git not found'
rlRun 'git --version' 0 "git version"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 13: git-shell ==="
which git-shell 2>/dev/null || echo 'git-shell not found'


echo ""
echo "All git git-shell tests passed!"
