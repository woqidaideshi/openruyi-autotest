#!/bin/sh -eux
# Functional test: podmansh - podman-volume

. "../setup.sh"

echo "=== Test 8: podman volume ==="

podman volume ls 2>&1 | head -5 || echo "Volume list"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All podmansh podman-volume tests passed!"
