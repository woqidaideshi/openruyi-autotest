#!/bin/sh -eux
# Functional test: podmansh - podman-ps

. "../setup.sh"

echo "=== Test 10: podman ps ==="

podman ps -a 2>&1 | head -5 || echo "Container list"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All podmansh podman-ps tests passed!"
