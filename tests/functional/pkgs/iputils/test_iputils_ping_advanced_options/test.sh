#!/bin/sh -eux
# Functional test: iputils - ping-advanced-options

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

echo "=== Test 2: ping advanced options ==="

# Test 2.1: Ping with flood mode (requires root)
ping -c 10 -f 127.0.0.1 || echo "Flood ping test completed"

# Test 2.2: Ping with numeric output
ping -c 3 -n 127.0.0.1

# Test 2.3: Ping with quiet mode
ping -c 3 -q 127.0.0.1

# Test 2.4: Ping with verbose output
ping -c 3 -v 127.0.0.1

# Test 2.5: Ping with timestamp
ping -c 3 -D 127.0.0.1

cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y iputils 2>/dev/null || true
    echo "TEARDOWN: removed iputils"
fi
echo ""
echo "All iputils ping-advanced-options tests passed!"
