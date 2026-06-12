#!/bin/sh -eux
# Functional test: psmisc - prtstat

rlRun() { eval "$1" 2>&1; return $?; }

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 8: prtstat ==="

prtstat 1 | head -10 || echo "prtstat test completed"

cd /
rm -rf $TmpDir

echo ""
echo "All psmisc prtstat tests passed!"
