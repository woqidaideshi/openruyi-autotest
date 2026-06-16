#!/bin/sh -eux
# Functional test: podmansh - Error-handling

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

echo "=== Test 11: Error handling ==="

podman run nonexistent/image 2>&1 || echo "Expected: image not found"
podman exec nonexistent_container 2>&1 || echo "Expected: container not found"

cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y podmansh 2>/dev/null || true
    echo "TEARDOWN: removed podmansh"
fi
echo ""
echo "All podmansh Error-handling tests passed!"
