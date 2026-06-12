#!/bin/sh -eux
# Functional test: git - Tag-operations

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q git-core' 0 "Check git-core installed"
rlRun 'which git' 0 "Check git available"
rlRun 'git --version' 0 "git version"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 7: Tag operations ==="
rlRun 'git tag v1.0' 0 "git tag: create tag"
rlRun 'git tag' 0 "git tag: list tags"
rlRun 'git tag -d v1.0' 0 "git tag -d: delete tag"


echo ""
echo "All git Tag-operations tests passed!"
