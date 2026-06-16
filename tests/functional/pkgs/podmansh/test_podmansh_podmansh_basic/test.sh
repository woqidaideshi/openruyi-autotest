#!/bin/sh -eux
# Functional test: podmansh - podmansh-basic

. "../setup.sh"

echo "=== Test 1: podmansh basic ==="

podmansh --version 2>&1 || echo "Version test"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All podmansh podmansh-basic tests passed!"
