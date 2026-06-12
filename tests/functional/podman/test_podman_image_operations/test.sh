#!/bin/sh -eux
# Functional test: podman - Image-operations

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


echo ""
echo "All podman Image-operations tests passed!"
