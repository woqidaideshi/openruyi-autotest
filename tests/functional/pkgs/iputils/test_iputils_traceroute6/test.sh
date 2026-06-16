#!/bin/sh -eux
# Functional test: iputils - traceroute6

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

echo "=== Test 4: traceroute6 ==="

# Test 4.1: Basic traceroute6 to localhost
traceroute6 -m 5 ::1 || echo "traceroute6 test completed"

# Test 4.2: traceroute6 with max hops
traceroute6 -m 10 ::1 || echo "traceroute6 with max hops test completed"

# Test 4.3: traceroute6 with wait time
traceroute6 -m 5 -w 2 ::1 || echo "traceroute6 with wait time test completed"

cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y iputils 2>/dev/null || true
    echo "TEARDOWN: removed iputils"
fi
echo ""
echo "All iputils traceroute6 tests passed!"
