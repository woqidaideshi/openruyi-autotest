#!/bin/sh -eux
# Functional test: pciutils - lspci-with-filtering

. "../setup.sh"

echo "=== Test 3: lspci with filtering ==="

lspci -nn | head -5
lspci -mm | head -5

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All pciutils lspci-with-filtering tests passed!"
