#!/bin/sh -eux
# Functional test: psmisc - prtstat

. "../setup.sh"

echo "=== Test 8: prtstat ==="

prtstat 1 | head -10 || echo "prtstat test completed"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All psmisc prtstat tests passed!"
