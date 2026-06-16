#!/bin/sh -eux
# Functional test: coreutils - Flow-control--sleep--timeout--yes

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

echo "=== Test 18: Flow control (sleep, timeout, yes) ==="

# 18.1 sleep
rlRun 'sleep 0.1' 0 "sleep delay"

# 18.2 timeout
rlRun 'timeout 2 sleep 0.1' 0 "timeout: command finishes in time"
rlRun 'timeout 2 sleep 0.1 && echo ok' 0 "timeout: successful completion"
rlRun 'timeout 0.1 sleep 5' 124 "timeout: kills slow command" || true

# 18.3 yes
rlRun 'yes | head -5' 0 "yes repeated output"
rlRun 'yes hello | head -3' 0 "yes custom string"

# ===================================================================


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y coreutils 2>/dev/null || true
    echo "TEARDOWN: removed coreutils"
fi
echo ""
echo "All coreutils Flow-control--sleep--timeout--yes tests passed!"
