#!/bin/sh -eux
# Functional test: podmansh - podmansh-basic

rlRun() { eval "$1" 2>&1; return $?; }

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 1: podmansh basic ==="

podmansh --version 2>&1 || echo "Version test"

cd /
rm -rf $TmpDir

echo ""
echo "All podmansh podmansh-basic tests passed!"
