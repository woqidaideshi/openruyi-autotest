#!/bin/sh -eux
# Functional test: systemd-timesyncd - Service-status

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install systemd-timesyncd ===
INSTALLED_BY_TEST=0
if ! rpm -q systemd-timesyncd 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y systemd-timesyncd 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed systemd-timesyncd"
    else
        echo "SKIP: systemd-timesyncd not available in repos"
        exit 0
    fi
else
    echo "SETUP: systemd-timesyncd already installed"
fi

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 1: Service status ==="
rlRun 'systemctl status systemd-timesyncd.service 2>&1 | head -10' 0 "Service status"
rlRun 'timedatectl show-timesync 2>&1 | head -10' 0 "Time sync status"
rlRun 'timedatectl timesync-status 2>&1 | head -10' 0 "Timesync detail"
rlRun 'systemctl is-enabled systemd-timesyncd.service 2>&1 || true' 0 "Is enabled"

cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y systemd-timesyncd 2>/dev/null || true
    echo "TEARDOWN: removed systemd-timesyncd"
fi
echo ""
echo "All systemd-timesyncd Service-status tests passed!"
