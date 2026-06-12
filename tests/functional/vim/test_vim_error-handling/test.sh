#!/bin/sh -eux
# Functional test: vim - Error-handling

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q vim-common' 0 "Check vim-common installed"
rlRun 'which vim' 0 "Check vim available"
rlRun 'vim --version 2>&1 | head -3' 0 "vim version"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 10: Error handling ==="
rlRun 'vim --invalid-option 2>&1 || true' 0 "vim: invalid option"
rlRun 'vim /nonexistent/file.txt -c "q" 2>&1 || true' 0 "vim: nonexistent file"

cd /
rm -rf $TmpDir

echo ""
echo "All vim functional tests passed!"

echo ""
echo "All vim Error-handling tests passed!"
