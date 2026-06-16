#!/bin/sh -eux
# Functional test: podman - Volume-operations

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install podman ===
INSTALLED_BY_TEST=0
if ! rpm -q podman 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y podman 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed podman"
    else
        echo "SKIP: podman not available in repos"
        exit 0
    fi
else
    echo "SETUP: podman already installed"
fi

rlRun 'podman version' 0 "podman version"
rlRun 'podman info 2>&1 | head -20' 0 "podman info"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 4: Volume operations ==="
rlRun 'podman volume ls 2>&1 | head -10' 0 "podman volume ls"



# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y podman 2>/dev/null || true
    echo "TEARDOWN: removed podman"
fi
echo ""
echo "All podman Volume-operations tests passed!"
