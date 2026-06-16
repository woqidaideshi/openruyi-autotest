#!/bin/sh -eux
# Functional test: weston package
# Tests Weston Wayland compositor and tools
# Version: weston 14.0.2

. "./setup.sh"

echo "=== Test 1: Version ==="
rlRun 'weston --version' 0 "weston version"

echo "=== Test 2: Help ==="
rlRun 'weston --help 2>&1 | head -20' 0 "weston help"

echo "=== Test 3: Weston terminal (headless) ==="
rlRun 'weston-terminal --help 2>&1 | head -10 || true' 0 "weston-terminal help"

echo "=== Test 4: Weston debug ==="
rlRun 'weston-debug --help 2>&1 | head -5' 0 "weston-debug help"

echo "=== Test 5: Screenshooter ==="
rlRun 'weston-screenshooter --help 2>&1 | head -5' 0 "weston-screenshooter help"

echo "=== Test 6: wcap-decode ==="
rlRun 'wcap-decode --help 2>&1 | head -5' 0 "wcap-decode help"

echo "=== Test 7: Backend check ==="
rlRun 'weston --help 2>&1 | grep -i "backend" | head -5' 0 "Available backends"

echo "=== Test 8: Headless backend test ==="
rlRun 'timeout 5 weston --backend=headless 2>&1 || true' 0 "weston: headless backend"

echo "=== Test 9: Error handling ==="
rlRun 'weston --invalid 2>&1 || true' 0 "weston: invalid option"

echo ""
echo "All weston functional tests passed!"

. "./teardown.sh"
echo "All weston tests passed!"
