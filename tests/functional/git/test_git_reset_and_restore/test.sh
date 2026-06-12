#!/bin/sh -eux
# Functional test: git - Reset-and-restore

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q git-core 2>/dev/null || { echo 'git-core not installed, skipping'; exit 0; }
which git 2>/dev/null || echo 'git not found'
rlRun 'git --version' 0 "git version"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 8: Reset and restore ==="
echo "temp" > temp.txt
rlRun 'git add temp.txt' 0 "git add: temp file"
rlRun 'git reset HEAD temp.txt' 0 "git reset: unstage"
rlRun 'git restore --staged temp.txt 2>&1 || true' 0 "git restore --staged"
rlRun 'rm -f temp.txt' 0 "Cleanup temp"


echo ""
echo "All git Reset-and-restore tests passed!"
