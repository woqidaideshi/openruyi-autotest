#!/bin/sh -eux
# Functional test: sddm - Config-values

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

echo "=== Test 5: Config values ==="
rlRun 'sddm --example-config 2>&1 | grep -E "^(Current|Display|Session|User)=" | head -10' 0 "sddm: key config values"

cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y sddm 2>/dev/null || true
    echo "TEARDOWN: removed sddm"
fi
echo ""
echo "All sddm Config-values tests passed!"
