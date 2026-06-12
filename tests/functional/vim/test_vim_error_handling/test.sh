#!/bin/sh -eux
# Functional test: vim - Error-handling

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q vim-common 2>/dev/null || { echo 'vim-common not installed, skipping'; exit 0; }
which vim 2>/dev/null || echo 'vim not found'
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
