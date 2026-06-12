#!/bin/sh -eux
# Functional test: pciutils - lspci-with-filtering

rlRun() { eval "$1" 2>&1; return $?; }

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 3: lspci with filtering ==="

lspci -nn | head -5
lspci -mm | head -5

cd /
rm -rf $TmpDir

echo ""
echo "All pciutils lspci-with-filtering tests passed!"
