#!/bin/sh -eux
# Functional test: procps-ng - ps-command-advanced-features

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

echo "=== Test 2: ps command advanced features ==="

# Test 2.1: Filter by user
ps -u root | head -10

# Test 2.2: Filter by PID
ps -p 1

# Test 2.3: Show threads
ps -eLf | head -10

# Test 2.4: Process hierarchy
ps --forest | head -20

# Test 2.5: Sort by CPU usage
ps aux --sort=-%cpu | head -10

# Test 2.6: Sort by memory usage
ps aux --sort=-%mem | head -10

cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y procps-ng 2>/dev/null || true
    echo "TEARDOWN: removed procps-ng"
fi
echo ""
echo "All procps-ng ps-command-advanced-features tests passed!"
