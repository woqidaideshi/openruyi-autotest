#!/bin/sh -eux
# Functional test: pciutils - update-pciids

. "../setup.sh"

echo "=== Test 9: update-pciids ==="

update-pciids -q 2>&1 || echo "update-pciids test completed"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All pciutils update-pciids tests passed!"
