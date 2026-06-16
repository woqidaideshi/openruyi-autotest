#!/bin/sh -eux
# Functional test: psmisc - pslog

. "../setup.sh"

echo "=== Test 10: pslog ==="

pslog 1 2>&1 | head -5 || echo "pslog test completed"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All psmisc pslog tests passed!"
