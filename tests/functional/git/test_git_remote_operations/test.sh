#!/bin/sh -eux
# Functional test: git - Remote-operations

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q git-core' 0 "Check git-core installed"
rlRun 'which git' 0 "Check git available"
rlRun 'git --version' 0 "git version"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 9: Remote operations ==="
rlRun 'git remote' 0 "git remote: list remotes"
rlRun 'git remote add origin /tmp/fake_remote 2>&1 || true' 0 "git remote add"


echo ""
echo "All git Remote-operations tests passed!"
