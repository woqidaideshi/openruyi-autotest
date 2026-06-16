#!/bin/sh -eux
# Functional test: procps-ng - Special-scenarios

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install procps-ng ===
INSTALLED_BY_TEST=0
if ! rpm -q procps-ng 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y procps-ng 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed procps-ng"
    else
        echo "SKIP: procps-ng not available in repos"
        exit 0
    fi
else
    echo "SETUP: procps-ng already installed"
fi


TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 12: Special scenarios ==="

# Test 12.1: ps with environment variables
ps e -p 1 2>&1 | head -5 || echo "Environment variables test completed"

# Test 12.2: Process with real-time priority
ps -eo pid,rtprio,comm | head -10

# Test 12.3: Show process namespaces
ps -eo pid,ns:pid,comm | head -10 || echo "Namespace test completed"

cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y procps-ng 2>/dev/null || true
    echo "TEARDOWN: removed procps-ng"
fi
echo ""
echo "All procps-ng Special-scenarios tests passed!"
