#!/bin/sh -eux
# Functional test: podman - Help-commands

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q podman' 0 "Check podman installed"
rlRun 'which podman' 0 "Check podman available"
rlRun 'which podman-remote' 0 "Check podman-remote available"
rlRun 'podman version' 0 "podman version"
rlRun 'podman info 2>&1 | head -20' 0 "podman info"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 6: Help commands ==="
rlRun 'podman manifest --help 2>&1 | head -5' 0 "podman manifest help"
rlRun 'podman healthcheck --help 2>&1 | head -5' 0 "podman healthcheck help"
rlRun 'podman events --help 2>&1 | head -5' 0 "podman events help"
rlRun 'podman pod list 2>&1 | head -5' 0 "podman pod list"
rlRun 'podman-remote --help 2>&1 | head -5' 0 "podman-remote help"


echo ""
echo "All podman Help-commands tests passed!"
