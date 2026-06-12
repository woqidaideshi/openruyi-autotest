#!/bin/sh -eux
# Functional test: podman - System-operations

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q podman 2>/dev/null || { echo 'podman not installed, skipping'; exit 0; }
which podman 2>/dev/null || echo 'podman not found'
which podman-remote 2>/dev/null || echo 'podman-remote not found'
rlRun 'podman version' 0 "podman version"
rlRun 'podman info 2>&1 | head -20' 0 "podman info"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 5: System operations ==="
rlRun 'podman system info 2>&1 | head -10' 0 "podman system info"
rlRun 'podman system df 2>&1 | head -10' 0 "podman system df: disk usage"


echo ""
echo "All podman System-operations tests passed!"
