#!/bin/sh -eux
# Functional test: pciutils - lspci-verbose

rlRun() { eval "$1" 2>&1; return $?; }

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 2: lspci verbose ==="

lspci -v | head -10
lspci -vv | head -5

cd /
rm -rf $TmpDir

echo ""
echo "All pciutils lspci-verbose tests passed!"
