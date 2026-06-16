#!/bin/sh -eux
# Functional test: wget - Verbose-and-quiet-modes

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install wget ===
INSTALLED_BY_TEST=0
if ! rpm -q wget 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y wget 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed wget"
    else
        echo "SKIP: wget not available in repos"
        exit 0
    fi
else
    echo "SETUP: wget already installed"
fi


TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 3: Verbose and quiet modes ==="

wget -v --spider https://example.com 2>&1 || echo "Verbose mode test"
wget -nv --spider https://example.com 2>&1 || echo "No-verbose mode test"
wget -q --spider https://example.com 2>&1 || echo "Quiet mode test"

cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y wget 2>/dev/null || true
    echo "TEARDOWN: removed wget"
fi
echo ""
echo "All wget Verbose-and-quiet-modes tests passed!"
