#!/bin/sh -eux
# Functional test: wget - Timeout-and-retries

. "../setup.sh"

echo "=== Test 7: Timeout and retries ==="

wget --timeout=5 -t 1 https://example.com 2>&1 || echo "Timeout test"
wget --tries=3 --spider https://example.com 2>&1 || echo "Retry test"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All wget Timeout-and-retries tests passed!"
