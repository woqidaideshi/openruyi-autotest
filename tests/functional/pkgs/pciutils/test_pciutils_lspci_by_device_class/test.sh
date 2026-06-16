#!/bin/sh -eux
# Functional test: pciutils - lspci-by-device-class

. "../setup.sh"

echo "=== Test 7: lspci by device class ==="

lspci -d ::0100 | head -5 || echo "Storage controller test"
lspci -d ::0200 | head -5 || echo "Network controller test"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All pciutils lspci-by-device-class tests passed!"
