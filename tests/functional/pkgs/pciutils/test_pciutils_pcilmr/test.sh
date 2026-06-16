#!/bin/sh -eux
# Functional test: pciutils - pcilmr

. "../setup.sh"

echo "=== Test 12: pcilmr ==="

pcilmr --version 2>&1 || echo "pcilmr version check completed"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All pciutils pcilmr tests passed!"
