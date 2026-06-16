#!/bin/sh -eux
# Functional test: iputils - ping-basic-functionality

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

echo "=== Test 1: ping basic functionality ==="

# Test 1.1: Ping localhost
ping -c 3 127.0.0.1

# Test 1.2: Ping with count limit
ping -c 5 127.0.0.1

# Test 1.3: Ping with interval
ping -c 3 -i 0.5 127.0.0.1

# Test 1.4: Ping with packet size
ping -c 3 -s 64 127.0.0.1
ping -c 3 -s 1024 127.0.0.1

# Test 1.5: Ping with timeout
ping -c 3 -W 2 127.0.0.1

cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y iputils 2>/dev/null || true
    echo "TEARDOWN: removed iputils"
fi
echo ""
echo "All iputils ping-basic-functionality tests passed!"
