#!/bin/sh -eux
# Functional test: pciutils - lspci-tree-view

. "../setup.sh"

echo "=== Test 5: lspci tree view ==="

lspci -t | head -10

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All pciutils lspci-tree-view tests passed!"
