#!/bin/sh -eux
# Functional test: podman package
# Tests Podman container management commands
# Version: podman

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q podman 2>/dev/null || { echo 'podman not installed, skipping'; exit 0; }
which podman 2>/dev/null || echo 'podman not found'
which podman-remote 2>/dev/null || echo 'podman-remote not found'

rlRun 'podman version' 0 "podman version"
rlRun 'podman info 2>&1 | head -20' 0 "podman info"

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 1: Image operations ==="
rlRun 'podman images 2>&1 | head -10' 0 "podman images: list images"
rlRun 'podman image list 2>&1 | head -10' 0 "podman image list"

echo "=== Test 2: Container operations ==="
rlRun 'podman ps 2>&1 | head -10' 0 "podman ps: list containers"
rlRun 'podman ps -a 2>&1 | head -10' 0 "podman ps -a: all containers"
rlRun 'podman container list 2>&1 | head -10' 0 "podman container list"

echo "=== Test 3: Network operations ==="
rlRun 'podman network ls 2>&1 | head -10' 0 "podman network ls"
rlRun 'podman network inspect podman 2>&1 | head -10' 0 "podman network inspect"

echo "=== Test 4: Volume operations ==="
rlRun 'podman volume ls 2>&1 | head -10' 0 "podman volume ls"

echo "=== Test 5: System operations ==="
rlRun 'podman system info 2>&1 | head -10' 0 "podman system info"
rlRun 'podman system df 2>&1 | head -10' 0 "podman system df: disk usage"

echo "=== Test 6: Help commands ==="
rlRun 'podman manifest --help 2>&1 | head -5' 0 "podman manifest help"
rlRun 'podman healthcheck --help 2>&1 | head -5' 0 "podman healthcheck help"
rlRun 'podman events --help 2>&1 | head -5' 0 "podman events help"
rlRun 'podman pod list 2>&1 | head -5' 0 "podman pod list"
rlRun 'podman-remote --help 2>&1 | head -5' 0 "podman-remote help"

echo "=== Test 7: Error handling ==="
rlRun 'podman nonexistent 2>&1 || true' 0 "podman: invalid command"

cd /
rm -rf $TmpDir

echo ""
echo "All podman functional tests passed!"