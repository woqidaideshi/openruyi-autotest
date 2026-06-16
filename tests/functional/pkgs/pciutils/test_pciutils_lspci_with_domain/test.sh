#!/bin/sh -eux
# Functional test: pciutils - lspci-with-domain

. "../setup.sh"

echo "=== Test 8: lspci with domain ==="

lspci -D | head -5

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All pciutils lspci-with-domain tests passed!"
