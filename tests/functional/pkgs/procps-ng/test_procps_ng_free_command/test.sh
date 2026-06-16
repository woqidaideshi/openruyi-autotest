#!/bin/sh -eux
# Functional test: procps-ng - free-command

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

echo "=== Test 3: free command ==="

# Test 3.1: Basic memory info
free

# Test 3.2: Human-readable format
free -h

# Test 3.3: Display in different units
free -b
free -k
free -m
free -g

# Test 3.4: Continuous monitoring (single iteration)
free -s 1 -c 1

# Test 3.5: Show total column
free -t

# Test 3.6: Show low/high memory
free -l

cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y procps-ng 2>/dev/null || true
    echo "TEARDOWN: removed procps-ng"
fi
echo ""
echo "All procps-ng free-command tests passed!"
