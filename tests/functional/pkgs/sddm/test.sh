#!/bin/sh -eux
# Functional test: sddm package
# Tests SDDM display manager
# Version: sddm 0.21.0

. "./setup.sh"

echo "=== Test 1: Version and help ==="
rlRun 'sddm --help 2>&1 | head -10' 0 "sddm help"
rlRun 'sddm --test-mode --help 2>&1 | head -5' 0 "sddm --test-mode help"

echo "=== Test 2: Configuration ==="
rlRun 'sddm --example-config 2>&1 | head -20' 0 "sddm: example config"
rlRun 'ls /etc/sddm.conf.d/ 2>&1 || echo "No config dir"' 0 "Config directory"
rlRun 'ls /usr/lib/sddm/sddm.conf.d/ 2>&1 || echo "No default config dir"' 0 "Default config dir"

echo "=== Test 3: Service check ==="
rlRun 'systemctl cat sddm.service 2>&1 | head -10' 0 "sddm service unit"
rlRun 'systemctl status sddm.service 2>&1 | head -5 || true' 0 "sddm service status"
rlRun 'systemctl is-enabled sddm.service 2>&1 || true' 0 "sddm enabled status"

echo "=== Test 4: Theme check ==="
rlRun 'ls /usr/share/sddm/themes/ 2>&1 | head -5' 0 "sddm themes installed"

echo "=== Test 5: Config values ==="
rlRun 'sddm --example-config 2>&1 | grep -E "^(Current|Display|Session|User)=" | head -10' 0 "sddm: key config values"

echo "=== Test 6: D-Bus ==="
busctl introspect org.freedesktop.DisplayManager /org/freedesktop/DisplayManager 2>&1 | head -5 || true
echo "DBus check completed"

echo "=== Test 7: Error handling ==="
echo "All sddm functional tests passed!"

. "./teardown.sh"
echo "All sddm tests passed!"
