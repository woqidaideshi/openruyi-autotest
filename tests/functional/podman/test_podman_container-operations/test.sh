#!/bin/sh -eux
# Functional test: podman - Container-operations

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q podman' 0 "Check podman installed"
rlRun 'which podman' 0 "Check podman available"
rlRun 'which podman-remote' 0 "Check podman-remote available"
rlRun 'podman version' 0 "podman version"
rlRun 'podman info 2>&1 | head -20' 0 "podman info"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 2: Container operations ==="
rlRun 'podman ps 2>&1 | head -10' 0 "podman ps: list containers"
rlRun 'podman ps -a 2>&1 | head -10' 0 "podman ps -a: all containers"
rlRun 'podman container list 2>&1 | head -10' 0 "podman container list"


echo ""
echo "All podman Container-operations tests passed!"
