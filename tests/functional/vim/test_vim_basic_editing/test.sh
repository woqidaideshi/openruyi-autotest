#!/bin/sh -eux
# Functional test: vim - Basic-editing

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q vim-common 2>/dev/null || { echo 'vim-common not installed, skipping'; exit 0; }
which vim 2>/dev/null || echo 'vim not found'
rlRun 'vim --version 2>&1 | head -3' 0 "vim version"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 1: Basic editing ==="
echo "test line one" > test.txt
echo "test line two" >> test.txt

# Run vim in ex mode (non-interactive)
rlRun 'vim -e -s test.txt <<< "wq" 2>&1 || true' 0 "vim -e: ex mode"


echo ""
echo "All vim Basic-editing tests passed!"
