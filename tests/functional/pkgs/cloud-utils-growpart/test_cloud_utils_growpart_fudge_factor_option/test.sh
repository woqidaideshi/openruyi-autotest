#!/bin/sh -eux
# Functional test: cloud-utils-growpart - Fudge-factor-option

. "../setup.sh"

echo "=== Test 5: Fudge factor option ==="
rlRun 'growpart --help 2>&1 | grep -q "fudge"' 0 "growpart: has fudge option"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All cloud-utils-growpart Fudge-factor-option tests passed!"
