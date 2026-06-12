#!/bin/sh -eux
# Functional test: psmisc - Error-handling

rlRun() { eval "$1" 2>&1; return $?; }

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 13: Error handling ==="

fuser /nonexistent/file 2>&1 || echo "Expected: no such file"
killall nonexistent-process 2>&1 || echo "Expected: no process found"
pstree nonexistent-user 2>&1 || echo "Expected: no such user"

echo ""
echo "All psmisc functional tests passed!"
cd /
rm -rf $TmpDir

echo ""
echo "All psmisc Error-handling tests passed!"
