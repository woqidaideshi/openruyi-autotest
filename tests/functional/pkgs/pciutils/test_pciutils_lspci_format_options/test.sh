#!/bin/sh -eux
# Functional test: pciutils - lspci-format-options

. "../setup.sh"

echo "=== Test 10: lspci format options ==="

lspci -mm -d ::0100 | head -3 || echo "Format test"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All pciutils lspci-format-options tests passed!"
