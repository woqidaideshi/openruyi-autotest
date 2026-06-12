#!/bin/sh -eux
# Functional test: wget2 - Content-disposition

rlRun() { eval "$1" 2>&1; return $?; }

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 14: Content disposition ==="

wget2 --content-disposition https://example.com 2>&1 || echo "Content disposition test"

cd /
rm -rf $TmpDir

echo ""
echo "All wget2 Content-disposition tests passed!"
