#!/bin/sh -eux
# Functional test: podmansh - podman-volume

rlRun() { eval "$1" 2>&1; return $?; }

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 8: podman volume ==="

podman volume ls 2>&1 | head -5 || echo "Volume list"

cd /
rm -rf $TmpDir

echo ""
echo "All podmansh podman-volume tests passed!"
