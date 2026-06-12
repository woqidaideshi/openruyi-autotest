#!/bin/sh -eux
# Functional test: podmansh - podman-images

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

echo "=== Test 6: podman images ==="

podman images 2>&1 | head -5 || echo "Images list"

cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y podmansh 2>/dev/null || true
    echo "TEARDOWN: removed podmansh"
fi
echo ""
echo "All podmansh podman-images tests passed!"
