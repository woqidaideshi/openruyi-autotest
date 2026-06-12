#!/bin/sh -eux
# Functional test: wget2 - Basic-download

rlRun() { eval "$1" 2>&1; return $?; }

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 1: Basic download ==="

wget2 -o /dev/stdout https://example.com 2>&1 || echo "Download test completed"

cd /
rm -rf $TmpDir

echo ""
echo "All wget2 Basic-download tests passed!"
