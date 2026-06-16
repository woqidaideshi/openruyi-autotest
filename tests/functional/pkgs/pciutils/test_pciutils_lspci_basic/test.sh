#!/bin/sh -eux
# Functional test: pciutils - lspci-basic

. "../setup.sh"

echo "=== Test 1: lspci basic ==="

lspci | head -10

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All pciutils lspci-basic tests passed!"
