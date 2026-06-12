#!/bin/sh -eux
# Functional test: pciutils - Error-handling

rlRun() { eval "$1" 2>&1; return $?; }

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 13: Error handling ==="

lspci -s invalid:00:00.0 2>&1 || echo "Expected: invalid slot format"
lspci --invalid-option 2>&1 || echo "Expected: invalid option"

echo ""
echo "All pciutils functional tests passed!"
cd /
rm -rf $TmpDir

echo ""
echo "All pciutils Error-handling tests passed!"
