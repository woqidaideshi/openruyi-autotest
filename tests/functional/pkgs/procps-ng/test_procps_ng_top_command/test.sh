#!/bin/sh -eux
# Functional test: procps-ng - top-command

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

echo "=== Test 4: top command ==="

# Test 4.1: Basic top (batch mode, single iteration)
top -b -n 1 | head -20

# Test 4.2: Top with specific number of processes
top -b -n 1 -p 1

# Test 4.3: Top sorted by memory
top -b -n 1 -o %MEM | head -20

# Test 4.4: Top with delay
top -b -n 1 -d 1 | head -10

cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y procps-ng 2>/dev/null || true
    echo "TEARDOWN: removed procps-ng"
fi
echo ""
echo "All procps-ng top-command tests passed!"
