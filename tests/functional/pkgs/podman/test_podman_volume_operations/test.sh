#!/bin/sh -eux
# Functional test: podman - Volume-operations

. "../setup.sh"

echo "=== Test 4: Volume operations ==="
rlRun 'podman volume ls 2>&1 | head -10' 0 "podman volume ls"

. "../teardown.sh"
echo "All podman Volume-operations tests passed!"
