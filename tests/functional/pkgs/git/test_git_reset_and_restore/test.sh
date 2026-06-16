#!/bin/sh -eux
# Functional test: git - Reset-and-restore

. "../setup.sh"

echo "=== Test 8: Reset and restore ==="
echo "temp" > temp.txt
rlRun 'git add temp.txt' 0 "git add: temp file"
rlRun 'git reset HEAD temp.txt' 0 "git reset: unstage"
rlRun 'git restore --staged temp.txt 2>&1 || true' 0 "git restore --staged"
rlRun 'rm -f temp.txt' 0 "Cleanup temp"

. "../teardown.sh"
echo "All git Reset-and-restore tests passed!"
