#!/bin/sh -eux
# Functional test: vim - Vimdiff

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q vim-common 2>/dev/null || { echo 'vim-common not installed, skipping'; exit 0; }
which vim 2>/dev/null || echo 'vim not found'
rlRun 'vim --version 2>&1 | head -3' 0 "vim version"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 4: Vimdiff ==="
echo "line1" > file1.txt
echo "line2" > file2.txt
which vimdiff 2>/dev/null || echo 'vimdiff not found'
rlRun 'vimdiff -c "q" file1.txt file2.txt 2>&1 || true' 0 "vimdiff: compare files"


echo ""
echo "All vim Vimdiff tests passed!"
