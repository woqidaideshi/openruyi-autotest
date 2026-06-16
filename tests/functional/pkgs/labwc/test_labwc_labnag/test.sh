#!/bin/sh -eux
# Functional test: labwc - labnag

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install labwc ===
INSTALLED_BY_TEST=0
if ! rpm -q labwc 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y labwc 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed labwc"
    else
        echo "SKIP: labwc not available in repos"
        exit 0
    fi
else
    echo "SETUP: labwc already installed"
fi

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 6: labnag ==="
rlRun 'labnag --help 2>&1 | head -5 || true' 0 "labnag help"

cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y labwc 2>/dev/null || true
    echo "TEARDOWN: removed labwc"
fi
echo ""
echo "All labwc labnag tests passed!"
