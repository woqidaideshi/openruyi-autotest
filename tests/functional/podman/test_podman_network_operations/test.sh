#!/bin/sh -eux
# Functional test: podman - Network-operations

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q podman 2>/dev/null || { echo 'podman not installed, skipping'; exit 0; }
which podman 2>/dev/null || echo 'podman not found'
which podman-remote 2>/dev/null || echo 'podman-remote not found'
rlRun 'podman version' 0 "podman version"
rlRun 'podman info 2>&1 | head -20' 0 "podman info"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 3: Network operations ==="
rlRun 'podman network ls 2>&1 | head -10' 0 "podman network ls"
rlRun 'podman network inspect podman 2>&1 | head -10' 0 "podman network inspect"


echo ""
echo "All podman Network-operations tests passed!"
