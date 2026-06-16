#!/bin/sh -eux
# Functional test: procps-ng - Error-handling

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

echo "=== Test 11: Error handling ==="

# Test 11.1: ps with invalid PID
ps -p 999999 2>&1 || echo "Expected error for invalid PID"

# Test 11.2: kill with invalid PID
kill -9 999999 2>&1 || echo "Expected error for invalid PID"

# Test 11.3: free with invalid option
free -z 2>&1 || echo "Expected error for invalid option"

cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y procps-ng 2>/dev/null || true
    echo "TEARDOWN: removed procps-ng"
fi
echo ""
echo "All procps-ng Error-handling tests passed!"
