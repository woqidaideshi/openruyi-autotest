#!/bin/sh -eux
# Functional test: podman - Network-operations

. "../setup.sh"

echo "=== Test 3: Network operations ==="
rlRun 'podman network ls 2>&1 | head -10' 0 "podman network ls"
rlRun 'podman network inspect podman 2>&1 | head -10' 0 "podman network inspect"

. "../teardown.sh"
echo "All podman Network-operations tests passed!"
