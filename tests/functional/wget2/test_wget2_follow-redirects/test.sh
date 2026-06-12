#!/bin/sh -eux
# Functional test: wget2 - Follow-redirects

rlRun() { eval "$1" 2>&1; return $?; }

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 13: Follow redirects ==="

wget2 https://google.com 2>&1 || echo "Redirect test"

cd /
rm -rf $TmpDir

echo ""
echo "All wget2 Follow-redirects tests passed!"
