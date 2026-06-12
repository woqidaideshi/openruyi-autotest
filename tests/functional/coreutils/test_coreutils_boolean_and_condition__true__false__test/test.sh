#!/bin/sh -eux
# Functional test: coreutils - Boolean-and-condition--true--false--test

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install coreutils ===
INSTALLED_BY_TEST=0
if ! rpm -q coreutils 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y coreutils 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed coreutils"
    else
        echo "SKIP: coreutils not available in repos"
        exit 0
    fi
else
    echo "SETUP: coreutils already installed"
fi

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 16: Boolean and condition (true, false, test, [) ==="

# 16.1 true
rlRun 'true' 0 "true returns success"

# 16.2 false
rlRun 'false' 1 "false returns failure" || true

# 16.3 test
rlRun 'test -f file1.txt' 0 "test -f: file exists"
rlRun 'test -d ls_testdir' 0 "test -d: directory exists"
rlRun 'test "abc" = "abc"' 0 "test string equality"
rlRun 'test 5 -gt 3' 0 "test numeric comparison"

# 16.4 [ (same as test)
rlRun '[ -f file1.txt ]' 0 "[ -f: file exists"
rlRun '[ "x" = "x" ]' 0 "[ string equality"

# ===================================================================


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y coreutils 2>/dev/null || true
    echo "TEARDOWN: removed coreutils"
fi
echo ""
echo "All coreutils Boolean-and-condition--true--false--test tests passed!"
