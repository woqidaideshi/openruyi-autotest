#!/bin/sh -eux
# Functional test: systemd - run0---Privilege-escalation

. "../setup.sh"

echo "=== Test 32: run0 - Privilege escalation ==="

rlRun 'run0 --help 2>&1 | head -5' 0 "run0 help"

# ===================================================================

. "../teardown.sh"
echo "All systemd run0---Privilege-escalation tests passed!"
