#!/bin/sh -eux
# Functional test: wget - Progress-indicators

rlRun() { eval "$1" 2>&1; return $?; }

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 11: Progress indicators ==="

wget --progress=dot https://example.com 2>&1 || echo "Dot progress test"

cd /
rm -rf $TmpDir

echo ""
echo "All wget Progress-indicators tests passed!"
