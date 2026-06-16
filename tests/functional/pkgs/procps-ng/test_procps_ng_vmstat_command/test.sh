#!/bin/sh -eux
# Functional test: procps-ng - vmstat-command

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

echo "=== Test 5: vmstat command ==="

# Test 5.1: Basic vmstat output
vmstat

# Test 5.2: vmstat with custom intervals
vmstat 1 2

# Test 5.3: vmstat with slabs info
vmstat -m | head -10

# Test 5.4: vmstat with disk stats
vmstat -d | head -10

# Test 5.5: vmstat with partitions
vmstat -p /dev/sda 2>&1 || echo "Expected: disk may not exist"

cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y procps-ng 2>/dev/null || true
    echo "TEARDOWN: removed procps-ng"
fi
echo ""
echo "All procps-ng vmstat-command tests passed!"
