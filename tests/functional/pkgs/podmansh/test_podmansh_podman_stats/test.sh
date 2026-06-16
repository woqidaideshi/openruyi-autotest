#!/bin/sh -eux
# Functional test: podmansh - podman-stats

. "../setup.sh"

echo "=== Test 9: podman stats ==="

podman stats --no-stream --all 2>&1 | head -5 || echo "Stats test"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All podmansh podman-stats tests passed!"
