#!/bin/sh -eux
# Functional test: coreutils - Octal-dump--od

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q coreutils' 0 "Check coreutils package is installed"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 9: Octal dump (od) ==="

rlRun 'od file1.txt' 0 "od octal dump"
rlRun 'od -c file1.txt' 0 "od -c character dump"
rlRun 'od -x file1.txt' 0 "od -x hex dump"
rlRun 'od -A x file1.txt' 0 "od -A x hex address"

# ===================================================================

echo ""
echo "All coreutils Octal-dump--od tests passed!"
