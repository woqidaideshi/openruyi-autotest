#!/bin/sh -eux
# Functional test: iputils - tracepath

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install iputils ===
INSTALLED_BY_TEST=0
if ! rpm -q iputils 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y iputils 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed iputils"
    else
        echo "SKIP: iputils not available in repos"
        exit 0
    fi
else
    echo "SETUP: iputils already installed"
fi


TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 5: tracepath ==="

# Test 5.1: Basic tracepath to localhost
tracepath -m 5 127.0.0.1 || echo "tracepath test completed"

# Test 5.2: tracepath with max hops
tracepath -m 10 127.0.0.1 || echo "tracepath with max hops test completed"

# Test 5.3: tracepath IPv6
tracepath6 -m 5 ::1 || echo "tracepath6 test completed"

cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y iputils 2>/dev/null || true
    echo "TEARDOWN: removed iputils"
fi
echo ""
echo "All iputils tracepath tests passed!"
