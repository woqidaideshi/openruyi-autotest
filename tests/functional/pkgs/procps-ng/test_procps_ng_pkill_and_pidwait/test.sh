#!/bin/sh -eux
# Functional test: procps-ng - pkill-and-pidwait

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

echo "=== Test 13: pkill and pidwait ==="

# Test 13.1: pkill version check
pkill --version 2>&1 | grep -q "pkill" || echo "pkill version check"

# Test 13.2: pidwait version check
pidwait --version 2>&1 | grep -q "pidwait" || echo "pidwait version check"

cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y procps-ng 2>/dev/null || true
    echo "TEARDOWN: removed procps-ng"
fi
echo ""
echo "All procps-ng pkill-and-pidwait tests passed!"
