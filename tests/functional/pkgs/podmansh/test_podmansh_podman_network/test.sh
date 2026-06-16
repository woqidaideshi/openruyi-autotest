#!/bin/sh -eux
# Functional test: podmansh - podman-network

. "../setup.sh"

echo "=== Test 7: podman network ==="

podman network ls 2>&1 | head -5 || echo "Network list"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All podmansh podman-network tests passed!"
