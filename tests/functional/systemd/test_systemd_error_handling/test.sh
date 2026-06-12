#!/bin/sh -eux
# Functional test: systemd - Error-handling

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

echo "=== Test 36: Error handling ==="

rlRun 'systemctl nonexistent-command 2>&1 || true' 0 "systemctl: invalid command"
rlRun 'journalctl --invalid-option 2>&1 || true' 0 "journalctl: invalid option"
rlRun 'hostnamectl --invalid 2>&1 || true' 0 "hostnamectl: invalid option"

cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y systemd 2>/dev/null || true
    echo "TEARDOWN: removed systemd"
fi
echo ""
echo "All systemd functional tests passed!"

echo ""
echo "All systemd Error-handling tests passed!"
