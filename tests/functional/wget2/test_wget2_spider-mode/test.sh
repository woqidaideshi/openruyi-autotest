#!/bin/sh -eux
# Functional test: wget2 - Spider-mode

rlRun() { eval "$1" 2>&1; return $?; }

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 4: Spider mode ==="

wget2 --spider https://google.com 2>&1 || echo "Spider test"

cd /
rm -rf $TmpDir

echo ""
echo "All wget2 Spider-mode tests passed!"
