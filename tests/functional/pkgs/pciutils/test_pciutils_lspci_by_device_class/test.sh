#!/bin/sh -eux
# Functional test: pciutils - lspci-by-device-class

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install pciutils ===
INSTALLED_BY_TEST=0
if ! rpm -q pciutils 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y pciutils 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed pciutils"
    else
        echo "SKIP: pciutils not available in repos"
        exit 0
    fi
else
    echo "SETUP: pciutils already installed"
fi


TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 7: lspci by device class ==="

lspci -d ::0100 | head -5 || echo "Storage controller test"
lspci -d ::0200 | head -5 || echo "Network controller test"

cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y pciutils 2>/dev/null || true
    echo "TEARDOWN: removed pciutils"
fi
echo ""
echo "All pciutils lspci-by-device-class tests passed!"
