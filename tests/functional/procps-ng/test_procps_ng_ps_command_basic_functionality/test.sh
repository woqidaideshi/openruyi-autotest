#!/bin/sh -eux
# Functional test: procps-ng - ps-command-basic-functionality

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

echo "=== Test 1: ps command basic functionality ==="

# Test 1.1: Basic ps output
ps

# Test 1.2: ps with full format
ps -ef

# Test 1.3: ps with custom format
ps -eo pid,comm,stat,%cpu,%mem

# Test 1.4: ps showing all processes
ps aux

# Test 1.5: ps with tree view
ps axjf | head -20

cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y procps-ng 2>/dev/null || true
    echo "TEARDOWN: removed procps-ng"
fi
echo ""
echo "All procps-ng ps-command-basic-functionality tests passed!"
