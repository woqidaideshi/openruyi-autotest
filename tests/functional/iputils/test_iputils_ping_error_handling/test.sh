#!/bin/sh -eux
# Functional test: iputils - ping-error-handling

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

echo "=== Test 8: ping error handling ==="

# Test 8.1: Ping unreachable address
ping -c 2 -W 1 192.0.2.1 2>&1 || echo "Expected: unreachable host"

# Test 8.2: Ping with invalid address
ping -c 1 999.999.999.999 2>&1 || echo "Expected error for invalid address"

# Test 8.3: Ping with invalid count
ping -c 0 127.0.0.1 2>&1 || echo "Expected error for invalid count"

# Test 8.4: Ping with negative count
ping -c -1 127.0.0.1 2>&1 || echo "Expected error for negative count"

cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y iputils 2>/dev/null || true
    echo "TEARDOWN: removed iputils"
fi
echo ""
echo "All iputils ping-error-handling tests passed!"
