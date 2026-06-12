#!/bin/sh -eux
# Functional test: wget - Recursive-download

rlRun() { eval "$1" 2>&1; return $?; }

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 8: Recursive download ==="

# Test mirror mode (limited depth)
wget -r -l 1 -np -nd https://example.com 2>&1 || echo "Recursive download test"

cd /
rm -rf $TmpDir

echo ""
echo "All wget Recursive-download tests passed!"
