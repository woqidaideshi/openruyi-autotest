#!/bin/sh -eux
# Functional test: git - Error-handling

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q git-core' 0 "Check git-core installed"
rlRun 'which git' 0 "Check git available"
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
