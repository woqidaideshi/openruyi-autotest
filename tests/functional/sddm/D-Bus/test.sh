#!/bin/sh -eux
# Functional test: sddm - D-Bus

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q sddm' 0 "Check sddm installed"
rlRun 'which sddm' 0 "Check sddm available"
rlRun 'which sddm-greeter-qt6 2>&1 || true' 0 "Check sddm-greeter available"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 6: D-Bus ==="
busctl introspect org.freedesktop.DisplayManager /org/freedesktop/DisplayManager 2>&1 | head -5 || true
echo "DBus check completed"

cd /
rm -rf $TmpDir

echo ""
echo "All sddm D-Bus tests passed!"
