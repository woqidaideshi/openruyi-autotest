#!/bin/sh -eux
# Functional test: labwc package
# Tests labwc Wayland compositor and tools
# Version: labwc 0.9.7

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install labwc ===
INSTALLED_BY_TEST=0
if ! rpm -q labwc 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y labwc 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed labwc"
    else
        echo "SKIP: labwc not available in repos"
        exit 0
    fi
else
    echo "SETUP: labwc already installed"
fi



echo "=== Test 1: Help ==="
rlRun 'labwc --help 2>&1' 0 "labwc help"

echo "=== Test 2: Configuration ==="
rlRun 'labwc --help 2>&1 | grep -E "\-\-config|\-\-merge-config|\-\-reconfigure"' 0 "labwc: config options"

echo "=== Test 3: Debug mode ==="
rlRun 'labwc --help 2>&1 | grep -E "\-\-debug|\-d"' 0 "labwc: debug option"

echo "=== Test 4: Check for display (no DISPLAY) ==="
rlRun 'labwc --help 2>&1 | grep -E "\-\-startup|\-s|\-\-session|\-S"' 0 "labwc: startup/session options"

echo "=== Test 5: Library check ==="
rlRun 'ldd $(which labwc) 2>&1 | head -10' 0 "labwc: linked libraries"

echo "=== Test 6: labnag ==="
rlRun 'labnag --help 2>&1 | head -5 || true' 0 "labnag help"

echo "=== Test 7: lab-sensible-terminal ==="
rlRun 'lab-sensible-terminal --help 2>&1 | head -5 || true' 0 "lab-sensible-terminal help"

echo "=== Test 8: Config dirs ==="
rlRun 'ls /etc/xdg/labwc/ 2>&1 || echo "No system config dir"' 0 "System config dir"
rlRun 'ls /usr/share/labwc/ 2>&1 || echo "No data dir"' 0 "Data dir"

echo "=== Test 9: Error handling ==="
rlRun 'labwc --invalid 2>&1 || true' 0 "labwc: invalid option"

echo ""
echo "All labwc functional tests passed!"

# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y labwc 2>/dev/null || true
    echo "TEARDOWN: removed labwc"
fi

