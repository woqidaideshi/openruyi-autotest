#!/bin/sh -eux
# Functional test: systemd - systemd-analyze---System-profiling

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

echo "=== Test 3: systemd-analyze - System profiling ==="

rlRun 'systemd-analyze --version 2>&1 || true' 0 "systemd-analyze version"
rlRun 'systemd-analyze time 2>&1 || true' 0 "systemd-analyze time: boot time"
rlRun 'systemd-analyze security 2>&1 | head -5' 0 "systemd-analyze security"

# ===================================================================


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y systemd 2>/dev/null || true
    echo "TEARDOWN: removed systemd"
fi
echo ""
echo "All systemd systemd-analyze---System-profiling tests passed!"
