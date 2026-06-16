#!/bin/sh -eux
# Functional test: pciutils - lspci-numeric

. "../setup.sh"

echo "=== Test 4: lspci numeric ==="

lspci -n | head -5
lspci -nnmm | head -5

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All pciutils lspci-numeric tests passed!"
