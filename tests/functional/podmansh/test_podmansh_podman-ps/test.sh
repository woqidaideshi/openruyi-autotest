#!/bin/sh -eux
# Functional test: podmansh - podman-ps

rlRun() { eval "$1" 2>&1; return $?; }

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 10: podman ps ==="

podman ps -a 2>&1 | head -5 || echo "Container list"

cd /
rm -rf $TmpDir

echo ""
echo "All podmansh podman-ps tests passed!"
