#!/bin/sh -eux
# Functional test: vim - Batch-ex-mode-commands

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q vim-common' 0 "Check vim-common installed"
rlRun 'which vim' 0 "Check vim available"
rlRun 'vim --version 2>&1 | head -3' 0 "vim version"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 2: Batch/ex mode commands ==="
rlRun 'echo "test content" | vim - -es "+%p" "+q!" 2>&1 | head -1' 0 "vim: print buffer"


echo ""
echo "All vim Batch-ex-mode-commands tests passed!"
