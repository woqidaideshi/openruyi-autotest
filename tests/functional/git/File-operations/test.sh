#!/bin/sh -eux
# Functional test: git - File-operations

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q git-core' 0 "Check git-core installed"
rlRun 'which git' 0 "Check git available"
rlRun 'git --version' 0 "git version"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 3: File operations ==="
echo "content1" > file1.txt
rlRun 'git add file1.txt' 0 "git add: stage file"
rlRun 'git status --short' 0 "git status --short"
rlRun 'git commit -m "initial commit"' 0 "git commit: first commit"
rlRun 'git log --oneline' 0 "git log: show commits"


echo ""
echo "All git File-operations tests passed!"
