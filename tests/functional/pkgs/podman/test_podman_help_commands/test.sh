#!/bin/sh -eux
# Functional test: podman - Help-commands

. "../setup.sh"

echo "=== Test 6: Help commands ==="
rlRun 'podman manifest --help 2>&1 | head -5' 0 "podman manifest help"
rlRun 'podman healthcheck --help 2>&1 | head -5' 0 "podman healthcheck help"
rlRun 'podman events --help 2>&1 | head -5' 0 "podman events help"
rlRun 'podman pod list 2>&1 | head -5' 0 "podman pod list"
rlRun 'podman-remote --help 2>&1 | head -5' 0 "podman-remote help"

. "../teardown.sh"
echo "All podman Help-commands tests passed!"
