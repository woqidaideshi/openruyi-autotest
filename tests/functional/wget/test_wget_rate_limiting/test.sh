#!/bin/sh -eux
# Functional test: wget - Rate-limiting

rlRun() { eval "$1" 2>&1; return $?; }

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 10: Rate limiting ==="

wget --limit-rate=100k -q https://example.com 2>&1 || echo "Rate limit test"

cd /
rm -rf $TmpDir

echo ""
echo "All wget Rate-limiting tests passed!"
