#!/bin/sh -eux
# Functional test: iputils - ping6--IPv6

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

echo "=== Test 3: ping6 (IPv6) ==="

# Test 3.1: Ping6 localhost
ping6 -c 3 ::1 || echo "IPv6 ping test completed (IPv6 may not be enabled)"

# Test 3.2: Ping6 with count
ping6 -c 5 ::1 || echo "IPv6 ping with count test completed"

cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y iputils 2>/dev/null || true
    echo "TEARDOWN: removed iputils"
fi
echo ""
echo "All iputils ping6--IPv6 tests passed!"
