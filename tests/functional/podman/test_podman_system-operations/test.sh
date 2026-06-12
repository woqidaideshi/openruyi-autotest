#!/bin/sh -eux
# Functional test: podman - System-operations

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q podman' 0 "Check podman installed"
rlRun 'which podman' 0 "Check podman available"
rlRun 'which podman-remote' 0 "Check podman-remote available"
rlRun 'podman version' 0 "podman version"
rlRun 'podman info 2>&1 | head -20' 0 "podman info"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 5: System operations ==="
rlRun 'podman system info 2>&1 | head -10' 0 "podman system info"
rlRun 'podman system df 2>&1 | head -10' 0 "podman system df: disk usage"


echo ""
echo "All podman System-operations tests passed!"
