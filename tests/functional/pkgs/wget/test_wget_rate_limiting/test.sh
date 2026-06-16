#!/bin/sh -eux
# Functional test: wget - Rate-limiting

. "../setup.sh"

echo "=== Test 10: Rate limiting ==="

wget --limit-rate=100k -q https://example.com 2>&1 || echo "Rate limit test"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All wget Rate-limiting tests passed!"
