#!/bin/sh -eux
# Functional test: systemd - systemd-path

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

echo "=== Test 16: systemd-path ==="

rlRun 'systemd-path' 0 "systemd-path: all paths"
rlRun 'systemd-path systemd-system-config' 0 "systemd-path: specific path"
rlRun 'systemd-path --suffix=test search-bin' 0 "systemd-path --suffix"
rlRun 'systemd-path --help 2>&1 | head -3' 0 "systemd-path help"

# ===================================================================


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y systemd 2>/dev/null || true
    echo "TEARDOWN: removed systemd"
fi
echo ""
echo "All systemd systemd-path tests passed!"
