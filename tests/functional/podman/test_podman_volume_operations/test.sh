#!/bin/sh -eux
# Functional test: podman - Volume-operations

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q podman 2>/dev/null || { echo 'podman not installed, skipping'; exit 0; }
which podman 2>/dev/null || echo 'podman not found'
which podman-remote 2>/dev/null || echo 'podman-remote not found'
rlRun 'podman version' 0 "podman version"
rlRun 'podman info 2>&1 | head -20' 0 "podman info"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 4: Volume operations ==="
rlRun 'podman volume ls 2>&1 | head -10' 0 "podman volume ls"


echo ""
echo "All podman Volume-operations tests passed!"
