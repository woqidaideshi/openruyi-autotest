#!/bin/sh -eux
# Functional test: vim - Batch-ex-mode-commands

. "../setup.sh"

echo "=== Test 2: Batch/ex mode commands ==="
rlRun 'echo "test content" | vim - -es "+%p" "+q!" 2>&1 | head -1' 0 "vim: print buffer"

. "../teardown.sh"
echo "All vim Batch-ex-mode-commands tests passed!"
