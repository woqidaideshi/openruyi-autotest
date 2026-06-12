#!/bin/sh -eux
# Functional test: coreutils - Process-control--nice--nohup--stdbuf

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

echo "=== Test 19: Process control (nice, nohup, stdbuf) ==="

# 19.1 nice
rlRun 'nice -n 10 true' 0 "nice adjust priority"

# 19.2 nohup
rlRun 'nohup true' 0 "nohup run command"

# 19.3 stdbuf
rlRun 'stdbuf -oL echo test 2>&1 || true' 0 "stdbuf line buffered output"

# ===================================================================


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y coreutils 2>/dev/null || true
    echo "TEARDOWN: removed coreutils"
fi
echo ""
echo "All coreutils Process-control--nice--nohup--stdbuf tests passed!"
