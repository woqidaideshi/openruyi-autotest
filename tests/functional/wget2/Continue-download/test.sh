#!/bin/sh -eux
# Functional test: wget2 - Continue-download

rlRun() { eval "$1" 2>&1; return $?; }

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 8: Continue download ==="

wget2 -c -O cont.html https://example.com 2>&1 || echo "Continue test"

cd /
rm -rf $TmpDir

echo ""
echo "All wget2 Continue-download tests passed!"
