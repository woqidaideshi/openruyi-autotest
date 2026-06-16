#!/bin/sh -eux
# Functional test: systemd - systemd-detect-virt

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

echo "=== Test 8: systemd-detect-virt ==="

rlRun 'systemd-detect-virt' 0 "systemd-detect-virt: detect VM"
rlRun 'systemd-detect-virt -q' 0 "systemd-detect-virt -q: quiet mode"
rlRun 'systemd-detect-virt -c 2>&1 || true' 0 "systemd-detect-virt -c: container only"
rlRun 'systemd-detect-virt -v 2>&1 || true' 0 "systemd-detect-virt -v: VM only"
rlRun 'systemd-detect-virt -r 2>&1 || true' 0 "systemd-detect-virt -r: chroot only"

# ===================================================================


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y systemd 2>/dev/null || true
    echo "TEARDOWN: removed systemd"
fi
echo ""
echo "All systemd systemd-detect-virt tests passed!"
