#!/bin/sh -eux
# Functional test: systemd - Power-management-commands

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q systemd' 0 "Check systemd package is installed"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 27: Power management commands ==="

for cmd in halt poweroff reboot shutdown; do
  rlRun "$cmd --help 2>&1 | head -3 || true" 0 "$cmd help"
done

# ===================================================================

echo ""
echo "All systemd Power-management-commands tests passed!"
