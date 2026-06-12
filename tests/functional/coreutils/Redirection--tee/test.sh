#!/bin/sh -eux
# Functional test: coreutils - Redirection--tee

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q coreutils' 0 "Check coreutils package is installed"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 12: Redirection (tee) ==="

rlRun 'echo "tee test" | tee tee_out.txt' 0 "tee write to file"
rlRun 'grep -q "tee test" tee_out.txt' 0 "tee: verify output"
rlRun 'echo "append" | tee -a tee_out.txt' 0 "tee -a append mode"

# ===================================================================

echo ""
echo "All coreutils Redirection--tee tests passed!"
