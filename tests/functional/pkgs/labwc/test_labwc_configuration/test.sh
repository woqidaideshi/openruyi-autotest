#!/bin/sh -eux
# Functional test: labwc - Configuration

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

echo "=== Test 2: Configuration ==="
rlRun 'labwc --help 2>&1 | grep -E "\-\-config|\-\-merge-config|\-\-reconfigure"' 0 "labwc: config options"

cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y labwc 2>/dev/null || true
    echo "TEARDOWN: removed labwc"
fi
echo ""
echo "All labwc Configuration tests passed!"
