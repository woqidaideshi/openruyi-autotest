#!/bin/sh -eux
# Functional test: coreutils - Redirection--tee

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q coreutils 2>/dev/null || { echo 'coreutils not installed, skipping'; exit 0; }
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 12: Redirection (tee) ==="

rlRun 'echo "tee test" | tee tee_out.txt' 0 "tee write to file"
rlRun 'grep -q "tee test" tee_out.txt' 0 "tee: verify output"
rlRun 'echo "append" | tee -a tee_out.txt' 0 "tee -a append mode"

# ===================================================================

echo ""
echo "All coreutils Redirection--tee tests passed!"
