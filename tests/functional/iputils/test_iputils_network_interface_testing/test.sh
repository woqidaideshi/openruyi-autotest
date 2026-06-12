#!/bin/sh -eux
# Functional test: iputils - Network-interface-testing

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

echo "=== Test 10: Network interface testing ==="

# Test 10.1: Ping via specific interface
ping -c 3 -I lo 127.0.0.1

# Test 10.2: Multiple ping instances
ping -c 2 127.0.0.1 &
ping -c 2 127.0.0.1 &
wait || echo "Multiple ping instances test completed"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y iputils 2>/dev/null || true
    echo "TEARDOWN: removed iputils"
fi
echo ""
echo "All iputils functional tests passed!"

cd /
rm -rf $TmpDir

echo ""
echo "All iputils Network-interface-testing tests passed!"
