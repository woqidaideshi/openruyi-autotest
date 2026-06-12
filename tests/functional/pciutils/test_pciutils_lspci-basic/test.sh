#!/bin/sh -eux
# Functional test: pciutils - lspci-basic

rlRun() { eval "$1" 2>&1; return $?; }

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 1: lspci basic ==="

lspci | head -10

cd /
rm -rf $TmpDir

echo ""
echo "All pciutils lspci-basic tests passed!"
