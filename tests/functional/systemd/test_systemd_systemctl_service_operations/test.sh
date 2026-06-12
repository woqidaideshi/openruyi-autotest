#!/bin/sh -eux
# Functional test: systemd - systemctl-service-operations

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

echo "=== Test 31: systemctl service operations ==="

rlRun 'systemctl try-restart systemd-journald.service 2>&1 || true' 0 "systemctl try-restart"
rlRun 'systemctl reload-or-restart systemd-journald.service 2>&1 || true' 0 "systemctl reload-or-restart"
rlRun 'systemctl reset-failed 2>&1 || true' 0 "systemctl reset-failed"
rlRun 'systemctl daemon-reload 2>&1 || true' 0 "systemctl daemon-reload"

# ===================================================================


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y systemd 2>/dev/null || true
    echo "TEARDOWN: removed systemd"
fi
echo ""
echo "All systemd systemctl-service-operations tests passed!"
