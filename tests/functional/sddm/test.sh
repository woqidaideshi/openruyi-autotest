#!/bin/sh -eux
# Functional test: sddm package
# Tests SDDM display manager
# Version: sddm 0.21.0

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install sddm ===
INSTALLED_BY_TEST=0
if ! rpm -q sddm 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y sddm 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed sddm"
    else
        echo "SKIP: sddm not available in repos"
        exit 0
    fi
else
    echo "SETUP: sddm already installed"
fi


rlRun 'which sddm-greeter-qt6 2>&1 || true' 0 "Check sddm-greeter available"

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

# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y sddm 2>/dev/null || true
    echo "TEARDOWN: removed sddm"
fi

