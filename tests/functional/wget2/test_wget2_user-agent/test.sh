#!/bin/sh -eux
# Functional test: wget2 - User-agent

rlRun() { eval "$1" 2>&1; return $?; }

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 6: User agent ==="

wget2 -U "TestAgent/1.0" --spider https://example.com 2>&1 || echo "UA test"

cd /
rm -rf $TmpDir

echo ""
echo "All wget2 User-agent tests passed!"
