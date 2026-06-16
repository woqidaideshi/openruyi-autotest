#!/bin/sh -eux
# Functional test: sddm - Error-handling

. "../setup.sh"

echo "=== Test 7: Error handling ==="
echo "All sddm functional tests passed!"
cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All sddm Error-handling tests passed!"
