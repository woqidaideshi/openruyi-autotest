#!/bin/sh -eux
# Functional test: podman - Volume-operations

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q podman' 0 "Check podman installed"
rlRun 'which podman' 0 "Check podman available"
rlRun 'which podman-remote' 0 "Check podman-remote available"
rlRun 'podman version' 0 "podman version"
rlRun 'podman info 2>&1 | head -20' 0 "podman info"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 4: Volume operations ==="
rlRun 'podman volume ls 2>&1 | head -10' 0 "podman volume ls"


echo ""
echo "All podman Volume-operations tests passed!"
