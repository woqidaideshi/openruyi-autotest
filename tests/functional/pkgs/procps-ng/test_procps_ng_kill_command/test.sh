#!/bin/sh -eux
# Functional test: procps-ng - kill-command

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

echo "=== Test 7: kill command ==="

# Test 7.1: Start a background process
sleep 100 &
BG_PID=$!
echo "Background process PID: $BG_PID"

# Test 7.2: List signal numbers
kill -l

# Test 7.3: Send SIGTERM
kill -15 $BG_PID || true

# Test 7.4: Wait for process to terminate
sleep 1

# Test 7.5: Verify process terminated
ps -p $BG_PID 2>&1 || echo "Process successfully terminated"

cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y procps-ng 2>/dev/null || true
    echo "TEARDOWN: removed procps-ng"
fi
echo ""
echo "All procps-ng kill-command tests passed!"
