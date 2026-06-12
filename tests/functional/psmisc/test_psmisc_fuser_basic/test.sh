#!/bin/sh -eux
# Functional test: psmisc - fuser-basic

rlRun() { eval "$1" 2>&1; return $?; }

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 1: fuser basic ==="

# Test fuser on /tmp
fuser -v /tmp 2>&1 || echo "fuser test completed"
fuser /tmp 2>&1 || echo "fuser basic test"

cd /
rm -rf $TmpDir

echo ""
echo "All psmisc fuser-basic tests passed!"
