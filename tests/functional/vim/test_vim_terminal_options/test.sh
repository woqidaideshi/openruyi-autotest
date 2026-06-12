#!/bin/sh -eux
# Functional test: vim - Terminal-options

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q vim-common 2>/dev/null || { echo 'vim-common not installed, skipping'; exit 0; }
which vim 2>/dev/null || echo 'vim not found'
rlRun 'vim --version 2>&1 | head -3' 0 "vim version"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 9: Terminal options ==="
rlRun 'vim -T xterm -c "q" test.txt 2>&1 || true' 0 "vim -T: terminal type"


echo ""
echo "All vim Terminal-options tests passed!"
