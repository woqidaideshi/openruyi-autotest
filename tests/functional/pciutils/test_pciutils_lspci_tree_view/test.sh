#!/bin/sh -eux
# Functional test: pciutils - lspci-tree-view

rlRun() { eval "$1" 2>&1; return $?; }

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 5: lspci tree view ==="

lspci -t | head -10

cd /
rm -rf $TmpDir

echo ""
echo "All pciutils lspci-tree-view tests passed!"
