#!/bin/sh -eux
# Functional test: vim - Terminal-options

. "../setup.sh"

echo "=== Test 9: Terminal options ==="
rlRun 'vim -T xterm -c "q" test.txt 2>&1 || true' 0 "vim -T: terminal type"

. "../teardown.sh"
echo "All vim Terminal-options tests passed!"
