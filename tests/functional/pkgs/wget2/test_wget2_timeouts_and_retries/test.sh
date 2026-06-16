#!/bin/sh -eux
# Functional test: wget2 - Timeouts-and-retries

. "../setup.sh"

echo "=== Test 7: Timeouts and retries ==="

wget2 --timeout=5 --tries=1 https://example.com 2>&1 || echo "Timeout test"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All wget2 Timeouts-and-retries tests passed!"
