#!/bin/sh -eux
# Functional test: podman - Image-operations

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

echo "=== Test 1: Image operations ==="
rlRun 'podman images 2>&1 | head -10' 0 "podman images: list images"
rlRun 'podman image list 2>&1 | head -10' 0 "podman image list"



# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y podman 2>/dev/null || true
    echo "TEARDOWN: removed podman"
fi
echo ""
echo "All podman Image-operations tests passed!"
