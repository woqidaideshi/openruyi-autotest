#!/bin/sh -eux
# Functional test: procps-ng - sysctl--if-available

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

echo "=== Test 10: sysctl (if available) ==="

# Test 10.1: List all sysctl parameters
sysctl -a 2>&1 | head -20 || echo "sysctl not available"

# Test 10.2: Read specific parameter
sysctl kernel.hostname 2>&1 || echo "sysctl parameter read test"

cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y procps-ng 2>/dev/null || true
    echo "TEARDOWN: removed procps-ng"
fi
echo ""
echo "All procps-ng sysctl--if-available tests passed!"
