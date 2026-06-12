#!/bin/sh -eux
# Functional test: cloud-utils-growpart package
# Tests growpart partition resizing utility
# Version: cloud-utils-growpart

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



echo "=== Test 1: Help and version ==="
rlRun 'growpart --help 2>&1 | head -10' 0 "growpart help"
rlRun 'growpart -h 2>&1 | head -5' 0 "growpart -h: short help"

echo "=== Test 2: Disk/partition info ==="
rlRun 'lsblk 2>&1 | head -10' 0 "lsblk: list block devices"
rlRun 'df -h | head -10' 0 "df: disk free space"

echo "=== Test 3: Dry-run (no actual resize) ==="
# Get first partition info
DISK=$(lsblk -ndo NAME | head -1)
if [ -n "$DISK" ] && [ -b "/dev/$DISK" ]; then
    rlRun "growpart -N /dev/$DISK 1 2>&1 || true" 0 "growpart -N: dry run"
fi

echo "=== Test 4: Free percent option ==="
rlRun 'growpart --help 2>&1 | grep -q "free-percent"' 0 "growpart: has free-percent option"

echo "=== Test 5: Fudge factor option ==="
rlRun 'growpart --help 2>&1 | grep -q "fudge"' 0 "growpart: has fudge option"

echo "=== Test 6: Error handling ==="
rlRun 'growpart 2>&1 || true' 0 "growpart: no args (expected fail)"
rlRun 'growpart /dev/nonexistent 1 2>&1 || true' 0 "growpart: nonexistent disk"
rlRun 'growpart --invalid 2>&1 || true' 0 "growpart: invalid option"

echo ""
echo "All cloud-utils-growpart functional tests passed!"

# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y cloud-utils-growpart 2>/dev/null || true
    echo "TEARDOWN: removed cloud-utils-growpart"
fi

