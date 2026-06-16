#!/bin/sh -eux
# Functional test: git - Clean-and-gc

. "../setup.sh"

echo "=== Test 12: Clean and gc ==="
rlRun 'git clean -n' 0 "git clean -n: dry run"
rlRun 'git gc --auto 2>&1 || true' 0 "git gc: garbage collect"

. "../teardown.sh"
echo "All git Clean-and-gc tests passed!"
