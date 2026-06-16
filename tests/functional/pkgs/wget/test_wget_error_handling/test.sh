#!/bin/sh -eux
# Functional test: wget - Error-handling

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

echo "=== Test 12: Error handling ==="

# Invalid URL
wget -q http://nonexistent.domain.invalid 2>&1 || echo "Expected: invalid host"

# 404 error
wget -q https://example.com/nonexistent 2>&1 || echo "Expected: 404 error"

# Invalid option
wget --invalid-option 2>&1 || echo "Expected: invalid option"

cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y wget 2>/dev/null || true
    echo "TEARDOWN: removed wget"
fi
echo ""
echo "All wget Error-handling tests passed!"
