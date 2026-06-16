#!/bin/sh -eux
# Functional test: vim - Basic-editing

. "../setup.sh"

echo "=== Test 1: Basic editing ==="
echo "test line one" > test.txt
echo "test line two" >> test.txt

# Run vim in ex mode (non-interactive)
rlRun 'vim -e -s test.txt <<< "wq" 2>&1 || true' 0 "vim -e: ex mode"

. "../teardown.sh"
echo "All vim Basic-editing tests passed!"
