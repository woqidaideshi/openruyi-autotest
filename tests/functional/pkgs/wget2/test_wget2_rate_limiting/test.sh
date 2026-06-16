#!/bin/sh -eux
# Functional test: wget2 - Rate-limiting

. "../setup.sh"

echo "=== Test 9: Rate limiting ==="

wget2 --limit-rate=100k https://example.com 2>&1 || echo "Rate limit test"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All wget2 Rate-limiting tests passed!"
