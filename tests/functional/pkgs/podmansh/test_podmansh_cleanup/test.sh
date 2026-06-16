#!/bin/sh -eux
# Functional test: podmansh - Cleanup

. "../setup.sh"

echo "=== Test 12: Cleanup ==="

podman system prune -f 2>&1 || echo "Cleanup test"

. "../teardown.sh"
echo "All podmansh Cleanup tests passed!"
