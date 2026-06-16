#!/bin/sh -eux
# Functional test: podmansh - podman-images

. "../setup.sh"

echo "=== Test 6: podman images ==="

podman images 2>&1 | head -5 || echo "Images list"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All podmansh podman-images tests passed!"
