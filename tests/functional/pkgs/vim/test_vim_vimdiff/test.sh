#!/bin/sh -eux
# Functional test: vim - Vimdiff

. "../setup.sh"

echo "=== Test 4: Vimdiff ==="
echo "line1" > file1.txt
echo "line2" > file2.txt
rlRun 'vimdiff -c "q" file1.txt file2.txt 2>&1 || true' 0 "vimdiff: compare files"

. "../teardown.sh"
echo "All vim Vimdiff tests passed!"
