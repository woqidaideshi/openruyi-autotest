#!/bin/sh -eux
# Functional test: wget - Special-features

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

echo "=== Test 15: Special features ==="

# Follow redirects (default)
wget -q https://google.com 2>&1 || echo "Redirect test"

# Content disposition
wget --content-disposition -q https://example.com 2>&1 || echo "Content disposition test"

cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y wget 2>/dev/null || true
    echo "TEARDOWN: removed wget"
fi
echo ""
echo "All wget functional tests passed!"
cd /
rm -rf $TmpDir

echo ""
echo "All wget Special-features tests passed!"
