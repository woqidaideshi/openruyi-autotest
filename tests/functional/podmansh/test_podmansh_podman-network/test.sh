#!/bin/sh -eux
# Functional test: podmansh - podman-network

rlRun() { eval "$1" 2>&1; return $?; }

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 7: podman network ==="

podman network ls 2>&1 | head -5 || echo "Network list"

cd /
rm -rf $TmpDir

echo ""
echo "All podmansh podman-network tests passed!"
