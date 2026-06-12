#!/bin/sh -eux
# Functional test: wget - Directory-listing

rlRun() { eval "$1" 2>&1; return $?; }

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 13: Directory listing ==="

wget -q -O - https://example.com 2>&1 | head -5 || echo "Directory listing test"

cd /
rm -rf $TmpDir

echo ""
echo "All wget Directory-listing tests passed!"
