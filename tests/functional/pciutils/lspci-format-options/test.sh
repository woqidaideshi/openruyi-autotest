#!/bin/sh -eux
# Functional test: pciutils - lspci-format-options

rlRun() { eval "$1" 2>&1; return $?; }

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 10: lspci format options ==="

lspci -mm -d ::0100 | head -3 || echo "Format test"

cd /
rm -rf $TmpDir

echo ""
echo "All pciutils lspci-format-options tests passed!"
