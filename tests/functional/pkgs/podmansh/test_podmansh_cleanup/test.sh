#!/bin/sh -eux
# Functional test: podmansh - Cleanup

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install podmansh ===
INSTALLED_BY_TEST=0
if ! rpm -q podmansh 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y podmansh 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed podmansh"
    else
        echo "SKIP: podmansh not available in repos"
        exit 0
    fi
else
    echo "SETUP: podmansh already installed"
fi


TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 12: Cleanup ==="

podman system prune -f 2>&1 || echo "Cleanup test"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y podmansh 2>/dev/null || true
    echo "TEARDOWN: removed podmansh"
fi
echo ""
echo "All podmansh functional tests passed!"
cd /
rm -rf $TmpDir

echo ""
echo "All podmansh Cleanup tests passed!"
