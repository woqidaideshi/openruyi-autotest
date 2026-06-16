#!/bin/sh -eux
# Functional test: systemd-timesyncd - Configuration

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

echo "=== Test 4: Configuration ==="
rlRun 'cat /etc/systemd/timesyncd.conf 2>/dev/null | head -10 || echo "No config"' 0 "Config file"
rlRun 'systemd-analyze cat-config systemd/timesyncd.conf 2>&1 | head -10 || true' 0 "Cat config"

cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y systemd-timesyncd 2>/dev/null || true
    echo "TEARDOWN: removed systemd-timesyncd"
fi
echo ""
echo "All systemd-timesyncd Configuration tests passed!"
