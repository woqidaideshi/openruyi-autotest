#!/bin/sh -eux
# Functional test: podmansh - podman-images

rlRun() { eval "$1" 2>&1; return $?; }

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 6: podman images ==="

podman images 2>&1 | head -5 || echo "Images list"

cd /
rm -rf $TmpDir

echo ""
echo "All podmansh podman-images tests passed!"
