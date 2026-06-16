#!/bin/sh -eux
# Functional test: podmansh - podmansh-help

. "../setup.sh"

echo "=== Test 2: podmansh help ==="

podmansh --help 2>&1 | head -20

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All podmansh podmansh-help tests passed!"
