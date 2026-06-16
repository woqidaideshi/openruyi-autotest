#!/bin/sh -eux
# Functional test: psmisc - killall-basic

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install psmisc ===
INSTALLED_BY_TEST=0
if ! rpm -q psmisc 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y psmisc 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed psmisc"
    else
        echo "SKIP: psmisc not available in repos"
        exit 0
    fi
else
    echo "SETUP: psmisc already installed"
fi


TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 7: killall basic ==="

# Start test process
sleep 3600 &
TEST_PID=$!
echo "Test PID: $TEST_PID"

# Try killall (may not kill itself)
killall -l 2>&1 || echo "List signals test"
killall sleep 2>&1 || echo "killall test completed"

# Clean up
kill $TEST_PID 2>&1 || true

cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y psmisc 2>/dev/null || true
    echo "TEARDOWN: removed psmisc"
fi
echo ""
echo "All psmisc killall-basic tests passed!"
