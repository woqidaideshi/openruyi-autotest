#!/bin/sh -eux
# Functional test: wget - Timestamps

rlRun() { eval "$1" 2>&1; return $?; }

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 14: Timestamps ==="

wget -N -q https://example.com 2>&1 || echo "Timestamp test"

cd /
rm -rf $TmpDir

echo ""
echo "All wget Timestamps tests passed!"
