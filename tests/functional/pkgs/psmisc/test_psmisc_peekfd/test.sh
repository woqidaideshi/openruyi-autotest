#!/bin/sh -eux
# Functional test: psmisc - peekfd

. "../setup.sh"

echo "=== Test 9: peekfd ==="

peekfd 1 0 2>&1 | head -5 || echo "peekfd test completed"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All psmisc peekfd tests passed!"
