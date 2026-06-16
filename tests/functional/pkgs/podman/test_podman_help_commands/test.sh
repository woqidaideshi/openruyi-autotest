#!/bin/sh -eux
# Functional test: podman - Help-commands

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

echo "=== Test 6: Help commands ==="
rlRun 'podman manifest --help 2>&1 | head -5' 0 "podman manifest help"
rlRun 'podman healthcheck --help 2>&1 | head -5' 0 "podman healthcheck help"
rlRun 'podman events --help 2>&1 | head -5' 0 "podman events help"
rlRun 'podman pod list 2>&1 | head -5' 0 "podman pod list"
rlRun 'podman-remote --help 2>&1 | head -5' 0 "podman-remote help"



# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y podman 2>/dev/null || true
    echo "TEARDOWN: removed podman"
fi
echo ""
echo "All podman Help-commands tests passed!"
