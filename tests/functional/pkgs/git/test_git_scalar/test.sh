#!/bin/sh -eux
# Functional test: git - scalar

. "../setup.sh"

echo "=== Test 14: scalar ==="
rlRun 'scalar --help 2>&1 | head -5' 0 "scalar help"

. "../teardown.sh"
echo "All git scalar tests passed!"
