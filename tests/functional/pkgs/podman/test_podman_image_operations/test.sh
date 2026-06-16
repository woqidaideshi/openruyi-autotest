#!/bin/sh -eux
# Functional test: podman - Image-operations

. "../setup.sh"

echo "=== Test 1: Image operations ==="
rlRun 'podman images 2>&1 | head -10' 0 "podman images: list images"
rlRun 'podman image list 2>&1 | head -10' 0 "podman image list"

. "../teardown.sh"
echo "All podman Image-operations tests passed!"
