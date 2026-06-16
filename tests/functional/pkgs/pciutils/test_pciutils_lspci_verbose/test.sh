#!/bin/sh -eux
# Functional test: pciutils - lspci-verbose

. "../setup.sh"

echo "=== Test 2: lspci verbose ==="

lspci -v | head -10
lspci -vv | head -5

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All pciutils lspci-verbose tests passed!"
