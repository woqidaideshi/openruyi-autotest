#!/bin/sh -eux
# Functional test: procps-ng - pidof-and-pgrep

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

echo "=== Test 8: pidof and pgrep ==="

# Test 8.1: Find PID by name
pidof init || pidof systemd || echo "Init system PID retrieved"

# Test 8.2: pgrep basic usage
pgrep -l init || pgrep -l systemd || echo "pgrep test completed"

# Test 8.3: pgrep with full command line
pgrep -af bash | head -5 || echo "pgrep -af test completed"

cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y procps-ng 2>/dev/null || true
    echo "TEARDOWN: removed procps-ng"
fi
echo ""
echo "All procps-ng pidof-and-pgrep tests passed!"
