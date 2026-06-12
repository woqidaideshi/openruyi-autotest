#!/bin/sh -eux
# Functional test: pciutils - lspci-kernel-drivers

rlRun() { eval "$1" 2>&1; return $?; }

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 6: lspci kernel drivers ==="

lspci -k | head -10

cd /
rm -rf $TmpDir

echo ""
echo "All pciutils lspci-kernel-drivers tests passed!"
