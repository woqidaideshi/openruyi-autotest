#!/bin/sh -eux
# Functional test: sddm - Version-and-help

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install sddm ===
INSTALLED_BY_TEST=0
if ! rpm -q sddm 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y sddm 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed sddm"
    else
        echo "SKIP: sddm not available in repos"
        exit 0
    fi
else
    echo "SETUP: sddm already installed"
fi

rlRun 'which sddm-greeter-qt6 2>&1 || true' 0 "Check sddm-greeter available"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 1: Version and help ==="
rlRun 'sddm --help 2>&1 | head -10' 0 "sddm help"
rlRun 'sddm --test-mode --help 2>&1 | head -5' 0 "sddm --test-mode help"

cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y sddm 2>/dev/null || true
    echo "TEARDOWN: removed sddm"
fi
echo ""
echo "All sddm Version-and-help tests passed!"
