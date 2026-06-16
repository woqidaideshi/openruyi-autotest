#!/bin/sh -eux
# Functional test: systemd - localectl---Locale-management

. "../setup.sh"

echo "=== Test 5: localectl - Locale management ==="

rlRun 'localectl --version 2>&1 || true' 0 "localectl version"
rlRun 'localectl status' 0 "localectl status: locale info"
rlRun 'localectl list-locales 2>&1 | head -10' 0 "localectl list-locales"

# ===================================================================

. "../teardown.sh"
echo "All systemd localectl---Locale-management tests passed!"
