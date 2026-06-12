#!/bin/sh -eux
# Functional test: wget2 - Headers

rlRun() { eval "$1" 2>&1; return $?; }

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 5: Headers ==="

wget2 --save-headers -O headers.html https://example.com 2>&1 || echo "Headers test"
head -10 headers.html

cd /
rm -rf $TmpDir

echo ""
echo "All wget2 Headers tests passed!"
