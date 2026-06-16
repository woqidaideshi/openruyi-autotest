#!/bin/sh -eux
# Functional test: podman - System-operations

. "../setup.sh"

echo "=== Test 5: System operations ==="
rlRun 'podman system info 2>&1 | head -10' 0 "podman system info"
rlRun 'podman system df 2>&1 | head -10' 0 "podman system df: disk usage"

. "../teardown.sh"
echo "All podman System-operations tests passed!"
