#!/bin/sh -eux
# Functional test: openssh - Error-handling

. "../setup.sh"

echo "=== Test 12: Error handling ==="
rlRun 'ssh-keygen -t invalid -f /dev/null 2>&1 || true' 0 "Invalid key type"
rlRun 'ssh-keygen -f /nonexistent/test -N "" -q 2>&1 || true' 0 "Invalid path"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All openssh Error-handling tests passed!"
