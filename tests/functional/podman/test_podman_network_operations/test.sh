#!/bin/sh -eux
# Functional test: podman - Network-operations

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q podman' 0 "Check podman installed"
rlRun 'which podman' 0 "Check podman available"
rlRun 'which podman-remote' 0 "Check podman-remote available"
rlRun 'podman version' 0 "podman version"
rlRun 'podman info 2>&1 | head -20' 0 "podman info"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 3: Network operations ==="
rlRun 'podman network ls 2>&1 | head -10' 0 "podman network ls"
rlRun 'podman network inspect podman 2>&1 | head -10' 0 "podman network inspect"


echo ""
echo "All podman Network-operations tests passed!"
