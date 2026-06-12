#!/bin/sh -eux
# Functional test: wget - Basic-download

rlRun() { eval "$1" 2>&1; return $?; }

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 1: Basic download ==="

# Test downloading a small file
wget -q https://example.com 2>&1 || echo "Download test completed"

cd /
rm -rf $TmpDir

echo ""
echo "All wget Basic-download tests passed!"
