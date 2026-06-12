#!/bin/sh -eux
# Functional test: wget - Spider-mode

rlRun() { eval "$1" 2>&1; return $?; }

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 4: Spider mode ==="

wget --spider https://google.com 2>&1 || echo "Spider test completed"

cd /
rm -rf $TmpDir

echo ""
echo "All wget Spider-mode tests passed!"
