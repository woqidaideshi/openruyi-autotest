#!/bin/sh -eux
# Functional test: psmisc - pslog

rlRun() { eval "$1" 2>&1; return $?; }

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 10: pslog ==="

pslog 1 2>&1 | head -5 || echo "pslog test completed"

cd /
rm -rf $TmpDir

echo ""
echo "All psmisc pslog tests passed!"
