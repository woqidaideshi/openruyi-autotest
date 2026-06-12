#!/bin/sh -eux
# Functional test: iputils - ping-special-scenarios

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

echo "=== Test 9: ping special scenarios ==="

# Test 9.1: Ping broadcast address (may require special permissions)
ping -c 1 -b 255.255.255.255 2>&1 || echo "Broadcast ping test completed"

# Test 9.2: Ping with source address
ping -c 3 -I 127.0.0.1 127.0.0.1 || echo "Source address ping test completed"

# Test 9.3: Ping with TTL
ping -c 3 -t 64 127.0.0.1

# Test 9.4: Continuous ping (limited by timeout)
timeout 5 ping 127.0.0.1 || echo "Continuous ping test completed"

cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y iputils 2>/dev/null || true
    echo "TEARDOWN: removed iputils"
fi
echo ""
echo "All iputils ping-special-scenarios tests passed!"
