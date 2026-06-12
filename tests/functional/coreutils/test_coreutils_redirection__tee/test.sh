#!/bin/sh -eux
# Functional test: coreutils - Redirection--tee

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

echo "=== Test 12: Redirection (tee) ==="

rlRun 'echo "tee test" | tee tee_out.txt' 0 "tee write to file"
rlRun 'grep -q "tee test" tee_out.txt' 0 "tee: verify output"
rlRun 'echo "append" | tee -a tee_out.txt' 0 "tee -a append mode"

# ===================================================================


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y coreutils 2>/dev/null || true
    echo "TEARDOWN: removed coreutils"
fi
echo ""
echo "All coreutils Redirection--tee tests passed!"
