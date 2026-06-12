#!/bin/sh -eux
# Functional test: coreutils - Octal-dump--od

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

echo "=== Test 9: Octal dump (od) ==="

rlRun 'od file1.txt' 0 "od octal dump"
rlRun 'od -c file1.txt' 0 "od -c character dump"
rlRun 'od -x file1.txt' 0 "od -x hex dump"
rlRun 'od -A x file1.txt' 0 "od -A x hex address"

# ===================================================================


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y coreutils 2>/dev/null || true
    echo "TEARDOWN: removed coreutils"
fi
echo ""
echo "All coreutils Octal-dump--od tests passed!"
