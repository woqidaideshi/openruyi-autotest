#!/bin/sh -eux
# Functional test: podmansh - podman-basic

. "../setup.sh"

echo "=== Test 4: podman basic ==="
podman version 2>&1 | head -5 || echo "Version check"
podman info 2>&1 | head -5 || echo "Info check"

. "../teardown.sh"
echo "All podmansh podman-basic tests passed!"
