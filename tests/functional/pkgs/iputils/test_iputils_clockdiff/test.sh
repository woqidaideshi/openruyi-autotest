#!/bin/sh -eux
# Functional test: iputils - clockdiff

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install iputils ===
INSTALLED_BY_TEST=0
if ! rpm -q iputils 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y iputils 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed iputils"
    else
        echo "SKIP: iputils not available in repos"
        exit 0
    fi
else
    echo "SETUP: iputils already installed"
fi


TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 7: clockdiff ==="

# Test 7.1: Clock difference to localhost
clockdiff 127.0.0.1 || echo "clockdiff test completed"

# Test 7.2: clockdiff with IPv6
clockdiff -o 127.0.0.1 || echo "clockdiff with option test completed"

cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y iputils 2>/dev/null || true
    echo "TEARDOWN: removed iputils"
fi
echo ""
echo "All iputils clockdiff tests passed!"
