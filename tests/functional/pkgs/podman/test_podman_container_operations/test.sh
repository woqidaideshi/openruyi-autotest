#!/bin/sh -eux
# Functional test: podman - Container-operations

. "../setup.sh"

echo "=== Test 2: Container operations ==="
rlRun 'podman ps 2>&1 | head -10' 0 "podman ps: list containers"
rlRun 'podman ps -a 2>&1 | head -10' 0 "podman ps -a: all containers"
rlRun 'podman container list 2>&1 | head -10' 0 "podman container list"

. "../teardown.sh"
echo "All podman Container-operations tests passed!"
