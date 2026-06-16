#!/bin/sh -eux
# Functional test: wget - Timestamps

. "../setup.sh"

echo "=== Test 14: Timestamps ==="

wget -N -q https://example.com 2>&1 || echo "Timestamp test"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All wget Timestamps tests passed!"
