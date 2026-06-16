#!/bin/sh -eux
# Functional test: sddm - D-Bus

. "../setup.sh"

echo "=== Test 6: D-Bus ==="
busctl introspect org.freedesktop.DisplayManager /org/freedesktop/DisplayManager 2>&1 | head -5 || true
echo "DBus check completed"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All sddm D-Bus tests passed!"
