#!/bin/sh -eux
# Functional test: pciutils - setpci

. "../setup.sh"

echo "=== Test 11: setpci ==="

setpci --dumpregs | head -10

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All pciutils setpci tests passed!"
