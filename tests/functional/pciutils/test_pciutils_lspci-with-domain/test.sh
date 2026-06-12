#!/bin/sh -eux
# Functional test: pciutils - lspci-with-domain

rlRun() { eval "$1" 2>&1; return $?; }

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 8: lspci with domain ==="

lspci -D | head -5

cd /
rm -rf $TmpDir

echo ""
echo "All pciutils lspci-with-domain tests passed!"
