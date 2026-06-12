#!/bin/sh -eux
# Functional test: git - git-shell

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q git-core' 0 "Check git-core installed"
rlRun 'which git' 0 "Check git available"
rlRun 'git --version' 0 "git version"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 13: git-shell ==="
rlRun 'which git-shell' 0 "git-shell available"


echo ""
echo "All git git-shell tests passed!"
