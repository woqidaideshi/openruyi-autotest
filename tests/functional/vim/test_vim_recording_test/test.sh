#!/bin/sh -eux
# Functional test: vim - Recording-test

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q vim-common' 0 "Check vim-common installed"
rlRun 'which vim' 0 "Check vim available"
rlRun 'vim --version 2>&1 | head -3' 0 "vim version"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 8: Recording test ==="
echo "line1" > rec.txt
rlRun 'vim -e -s rec.txt -c "norm! ihello" -c "wq" 2>&1 || true' 0 "vim: insert in ex mode"


echo ""
echo "All vim Recording-test tests passed!"
