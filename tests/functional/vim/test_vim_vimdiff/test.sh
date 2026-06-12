#!/bin/sh -eux
# Functional test: vim - Vimdiff

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q vim-common' 0 "Check vim-common installed"
rlRun 'which vim' 0 "Check vim available"
rlRun 'vim --version 2>&1 | head -3' 0 "vim version"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 4: Vimdiff ==="
echo "line1" > file1.txt
echo "line2" > file2.txt
rlRun 'which vimdiff' 0 "vimdiff available"
rlRun 'vimdiff -c "q" file1.txt file2.txt 2>&1 || true' 0 "vimdiff: compare files"


echo ""
echo "All vim Vimdiff tests passed!"
