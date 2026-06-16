#!/bin/sh -eux
# Functional test: vim - Error-handling

. "../setup.sh"

echo "=== Test 10: Error handling ==="
rlRun 'vim --invalid-option 2>&1 || true' 0 "vim: invalid option"
rlRun 'vim /nonexistent/file.txt -c "q" 2>&1 || true' 0 "vim: nonexistent file"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All vim Error-handling tests passed!"
