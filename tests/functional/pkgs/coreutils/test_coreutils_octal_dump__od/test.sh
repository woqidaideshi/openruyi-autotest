#!/bin/sh -eux
# Functional test: coreutils - Octal-dump--od

. "../setup.sh"

echo "=== Test 9: Octal dump (od) ==="

rlRun 'od file1.txt' 0 "od octal dump"
rlRun 'od -c file1.txt' 0 "od -c character dump"
rlRun 'od -x file1.txt' 0 "od -x hex dump"
rlRun 'od -A x file1.txt' 0 "od -A x hex address"

# ===================================================================

. "../teardown.sh"
echo "All coreutils Octal-dump--od tests passed!"
