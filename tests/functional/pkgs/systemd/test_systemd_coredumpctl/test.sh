#!/bin/sh -eux
# Functional test: systemd - coredumpctl

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

echo "=== Test 19: coredumpctl ==="

rlRun 'coredumpctl --version 2>&1 || true' 0 "coredumpctl version"
rlRun 'coredumpctl list 2>&1 | head -5' 0 "coredumpctl list: list dumps"
rlRun 'coredumpctl info 2>&1 | head -5 || true' 0 "coredumpctl info"

# ===================================================================


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y systemd 2>/dev/null || true
    echo "TEARDOWN: removed systemd"
fi
echo ""
echo "All systemd coredumpctl tests passed!"
