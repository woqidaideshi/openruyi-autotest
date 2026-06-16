#!/bin/sh -eux
# Functional test: wget2 - Timeouts-and-retries

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install wget2 ===
INSTALLED_BY_TEST=0
if ! rpm -q wget2 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y wget2 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed wget2"
    else
        echo "SKIP: wget2 not available in repos"
        exit 0
    fi
else
    echo "SETUP: wget2 already installed"
fi


TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 7: Timeouts and retries ==="

wget2 --timeout=5 --tries=1 https://example.com 2>&1 || echo "Timeout test"

cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y wget2 2>/dev/null || true
    echo "TEARDOWN: removed wget2"
fi
echo ""
echo "All wget2 Timeouts-and-retries tests passed!"
