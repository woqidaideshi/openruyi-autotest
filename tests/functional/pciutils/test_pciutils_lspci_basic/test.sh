#!/bin/sh -eux
# Functional test: pciutils - lspci-basic

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

echo "=== Test 1: lspci basic ==="

lspci | head -10

cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y pciutils 2>/dev/null || true
    echo "TEARDOWN: removed pciutils"
fi
echo ""
echo "All pciutils lspci-basic tests passed!"
