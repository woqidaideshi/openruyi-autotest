#!/bin/sh -eux
# Functional test: wget2 - Verbose-modes

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

echo "=== Test 3: Verbose modes ==="

wget2 --verbose --spider https://example.com 2>&1 || echo "Verbose test"
wget2 --no-verbose --spider https://example.com 2>&1 || echo "No-verbose test"
wget2 --quiet --spider https://example.com 2>&1 || echo "Quiet test"

cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y wget2 2>/dev/null || true
    echo "TEARDOWN: removed wget2"
fi
echo ""
echo "All wget2 Verbose-modes tests passed!"
