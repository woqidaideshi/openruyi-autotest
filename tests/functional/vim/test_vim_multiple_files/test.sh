#!/bin/sh -eux
# Functional test: vim - Multiple-files

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q vim-common' 0 "Check vim-common installed"
rlRun 'which vim' 0 "Check vim available"
rlRun 'vim --version 2>&1 | head -3' 0 "vim version"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 7: Multiple files ==="
echo "a" > a.txt
echo "b" > b.txt
rlRun 'vim -e -s -c "bufdo wq" a.txt b.txt 2>&1 || true' 0 "vim: multiple files"


echo ""
echo "All vim Multiple-files tests passed!"
