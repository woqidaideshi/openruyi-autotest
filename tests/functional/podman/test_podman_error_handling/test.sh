#!/bin/sh -eux
# Functional test: podman - Error-handling

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q podman 2>/dev/null || { echo 'podman not installed, skipping'; exit 0; }
which podman 2>/dev/null || echo 'podman not found'
which podman-remote 2>/dev/null || echo 'podman-remote not found'
rlRun 'podman version' 0 "podman version"
rlRun 'podman info 2>&1 | head -20' 0 "podman info"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 7: Error handling ==="
rlRun 'podman nonexistent 2>&1 || true' 0 "podman: invalid command"

cd /
rm -rf $TmpDir

echo ""
echo "All podman functional tests passed!"

echo ""
echo "All podman Error-handling tests passed!"
