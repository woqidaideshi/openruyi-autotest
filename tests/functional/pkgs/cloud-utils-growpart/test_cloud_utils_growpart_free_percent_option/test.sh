#!/bin/sh -eux
# Functional test: cloud-utils-growpart - Free-percent-option

. "../setup.sh"

echo "=== Test 4: Free percent option ==="
rlRun 'growpart --help 2>&1 | grep -q "free-percent"' 0 "growpart: has free-percent option"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All cloud-utils-growpart Free-percent-option tests passed!"
