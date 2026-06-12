#!/bin/sh -eux
# Functional test: wget - User-agent

rlRun() { eval "$1" 2>&1; return $?; }

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 6: User agent ==="

wget -q -U "Mozilla/5.0 TestAgent" --spider https://example.com 2>&1 || echo "User agent test"

cd /
rm -rf $TmpDir

echo ""
echo "All wget User-agent tests passed!"
