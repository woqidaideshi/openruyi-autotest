#!/bin/sh -eux
# Functional test: git - File-modifications

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q git-core' 0 "Check git-core installed"
rlRun 'which git' 0 "Check git available"
rlRun 'git --version' 0 "git version"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 5: File modifications ==="
echo "content2" > file2.txt
rlRun 'git add file2.txt' 0 "git add: second file"
rlRun 'git commit -m "add file2"' 0 "git commit: second commit"
echo "modified" >> file1.txt
rlRun 'git diff' 0 "git diff: show changes"
rlRun 'git diff --cached' 0 "git diff --cached: staged changes"
rlRun 'git add file1.txt && git commit -m "modify file1"' 0 "git commit: modify"


echo ""
echo "All git File-modifications tests passed!"
