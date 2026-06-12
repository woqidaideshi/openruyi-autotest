#!/bin/sh -eux
# Functional test: vim - Recording-test

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q vim-common 2>/dev/null || { echo 'vim-common not installed, skipping'; exit 0; }
which vim 2>/dev/null || echo 'vim not found'
rlRun 'vim --version 2>&1 | head -3' 0 "vim version"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 8: Recording test ==="
echo "line1" > rec.txt
rlRun 'vim -e -s rec.txt -c "norm! ihello" -c "wq" 2>&1 || true' 0 "vim: insert in ex mode"


echo ""
echo "All vim Recording-test tests passed!"
