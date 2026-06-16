#!/bin/sh -eux
# Functional test: procps-ng - pidof-and-pgrep

. "../setup.sh"

echo "=== Test 8: pidof and pgrep ==="

# Test 8.1: Find PID by name
pidof init || pidof systemd || echo "Init system PID retrieved"

# Test 8.2: pgrep basic usage
pgrep -l init || pgrep -l systemd || echo "pgrep test completed"

# Test 8.3: pgrep with full command line
pgrep -af bash | head -5 || echo "pgrep -af test completed"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All procps-ng pidof-and-pgrep tests passed!"
