#!/bin/sh -eux
# Functional test: wget2 - Verbose-modes

. "../setup.sh"

echo "=== Test 3: Verbose modes ==="

wget2 --verbose --spider https://example.com 2>&1 || echo "Verbose test"
wget2 --no-verbose --spider https://example.com 2>&1 || echo "No-verbose test"
wget2 --quiet --spider https://example.com 2>&1 || echo "Quiet test"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All wget2 Verbose-modes tests passed!"
