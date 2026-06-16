#!/bin/sh -eux
# Functional test: git - File-operations

. "../setup.sh"

echo "=== Test 3: File operations ==="
echo "content1" > file1.txt
rlRun 'git add file1.txt' 0 "git add: stage file"
rlRun 'git status --short' 0 "git status --short"
rlRun 'git commit -m "initial commit"' 0 "git commit: first commit"
rlRun 'git log --oneline' 0 "git log: show commits"

. "../teardown.sh"
echo "All git File-operations tests passed!"
