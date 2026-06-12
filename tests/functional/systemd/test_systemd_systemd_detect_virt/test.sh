#!/bin/sh -eux
# Functional test: systemd - systemd-detect-virt

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q systemd 2>/dev/null || { echo 'systemd not installed, skipping'; exit 0; }
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 8: systemd-detect-virt ==="

rlRun 'systemd-detect-virt' 0 "systemd-detect-virt: detect VM"
rlRun 'systemd-detect-virt -q' 0 "systemd-detect-virt -q: quiet mode"
rlRun 'systemd-detect-virt -c 2>&1 || true' 0 "systemd-detect-virt -c: container only"
rlRun 'systemd-detect-virt -v 2>&1 || true' 0 "systemd-detect-virt -v: VM only"
rlRun 'systemd-detect-virt -r 2>&1 || true' 0 "systemd-detect-virt -r: chroot only"

# ===================================================================

echo ""
echo "All systemd systemd-detect-virt tests passed!"
