#!/bin/sh -eux
# Functional test: coreutils - Redirection--tee

. "../setup.sh"

echo "=== Test 12: Redirection (tee) ==="

rlRun 'echo "tee test" | tee tee_out.txt' 0 "tee write to file"
rlRun 'grep -q "tee test" tee_out.txt' 0 "tee: verify output"
rlRun 'echo "append" | tee -a tee_out.txt' 0 "tee -a append mode"

# ===================================================================

. "../teardown.sh"
echo "All coreutils Redirection--tee tests passed!"
