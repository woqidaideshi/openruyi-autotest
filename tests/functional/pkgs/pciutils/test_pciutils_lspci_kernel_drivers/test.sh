#!/bin/sh -eux
# Functional test: pciutils - lspci-kernel-drivers

. "../setup.sh"

echo "=== Test 6: lspci kernel drivers ==="

lspci -k | head -10

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All pciutils lspci-kernel-drivers tests passed!"
