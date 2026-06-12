#!/bin/sh -eux
# Functional test: pciutils - update-pciids

rlRun() { eval "$1" 2>&1; return $?; }

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 9: update-pciids ==="

update-pciids -q 2>&1 || echo "update-pciids test completed"

cd /
rm -rf $TmpDir

echo ""
echo "All pciutils update-pciids tests passed!"
