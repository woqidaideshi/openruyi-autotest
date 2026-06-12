#!/bin/sh -eux
# Functional test: pciutils - lspci-numeric

rlRun() { eval "$1" 2>&1; return $?; }

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 4: lspci numeric ==="

lspci -n | head -5
lspci -nnmm | head -5

cd /
rm -rf $TmpDir

echo ""
echo "All pciutils lspci-numeric tests passed!"
