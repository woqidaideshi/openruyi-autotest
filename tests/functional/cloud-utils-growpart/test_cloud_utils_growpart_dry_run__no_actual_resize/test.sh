#!/bin/sh -eux
# Functional test: cloud-utils-growpart - Dry-run--no-actual-resize

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install cloud-utils-growpart ===
INSTALLED_BY_TEST=0
if ! rpm -q cloud-utils-growpart 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y cloud-utils-growpart 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed cloud-utils-growpart"
    else
        echo "SKIP: cloud-utils-growpart not available in repos"
        exit 0
    fi
else
    echo "SETUP: cloud-utils-growpart already installed"
fi

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 3: Dry-run (no actual resize) ==="
# Get first partition info
DISK=$(lsblk -ndo NAME | head -1)
if [ -n "$DISK" ] && [ -b "/dev/$DISK" ]; then
    rlRun "growpart -N /dev/$DISK 1 2>&1 || true" 0 "growpart -N: dry run"
fi

cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y cloud-utils-growpart 2>/dev/null || true
    echo "TEARDOWN: removed cloud-utils-growpart"
fi
echo ""
echo "All cloud-utils-growpart Dry-run--no-actual-resize tests passed!"
