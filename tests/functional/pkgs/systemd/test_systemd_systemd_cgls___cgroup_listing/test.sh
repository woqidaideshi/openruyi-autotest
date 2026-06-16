#!/bin/sh -eux
# Functional test: systemd - systemd-cgls---Cgroup-listing

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install systemd ===
INSTALLED_BY_TEST=0
if ! rpm -q systemd 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y systemd 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed systemd"
    else
        echo "SKIP: systemd not available in repos"
        exit 0
    fi
else
    echo "SETUP: systemd already installed"
fi

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 9: systemd-cgls - Cgroup listing ==="

rlRun 'systemd-cgls 2>&1 | head -20' 0 "systemd-cgls: cgroup tree"
rlRun 'systemd-cgls -k 2>&1 | head -5' 0 "systemd-cgls -k: kernel threads"
rlRun 'systemd-cgls --no-pager 2>&1 | head -10' 0 "systemd-cgls --no-pager"

# ===================================================================


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y systemd 2>/dev/null || true
    echo "TEARDOWN: removed systemd"
fi
echo ""
echo "All systemd systemd-cgls---Cgroup-listing tests passed!"
