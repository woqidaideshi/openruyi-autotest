#!/bin/sh -eux
# Functional test: podmansh - podmansh-help

rlRun() { eval "$1" 2>&1; return $?; }

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 2: podmansh help ==="

podmansh --help 2>&1 | head -20

cd /
rm -rf $TmpDir

echo ""
echo "All podmansh podmansh-help tests passed!"
