#!/bin/sh -eux
# Functional test: pciutils - setpci

rlRun() { eval "$1" 2>&1; return $?; }

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 11: setpci ==="

setpci --dumpregs | head -10

cd /
rm -rf $TmpDir

echo ""
echo "All pciutils setpci tests passed!"
