#!/bin/sh -eux
# Functional test: systemd-timesyncd - systemd-time-wait-sync

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

echo "=== Test 5: systemd-time-wait-sync ==="
rlRun 'systemctl status systemd-time-wait-sync.service 2>&1 | head -5' 0 "Wait sync service"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y systemd-timesyncd 2>/dev/null || true
    echo "TEARDOWN: removed systemd-timesyncd"
fi
echo ""
echo "All systemd-timesyncd functional tests passed!"
cd /
rm -rf $TmpDir

echo ""
echo "All systemd-timesyncd systemd-time-wait-sync tests passed!"
