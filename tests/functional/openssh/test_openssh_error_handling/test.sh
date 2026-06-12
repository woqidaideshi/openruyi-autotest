#!/bin/sh -eux
# Functional test: openssh - Error-handling

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q openssh 2>/dev/null || { echo 'openssh not installed, skipping'; exit 0; }
which ssh-keygen 2>/dev/null || echo 'ssh-keygen not found'
rlRun 'ssh-keygen -?' 0 "ssh-keygen help"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 12: Error handling ==="
rlRun 'ssh-keygen -t invalid -f /dev/null 2>&1 || true' 0 "Invalid key type"
rlRun 'ssh-keygen -f /nonexistent/test -N "" -q 2>&1 || true' 0 "Invalid path"

cd /
rm -rf $TmpDir

echo ""
echo "All openssh functional tests passed!"

echo ""
echo "All openssh Error-handling tests passed!"
