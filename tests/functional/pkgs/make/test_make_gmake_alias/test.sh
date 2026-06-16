#!/bin/sh -eux
# Functional test: make - gmake-alias

. "../setup.sh"

echo "=== Test 8: gmake alias ==="
rlRun 'gmake --version 2>&1 | grep "GNU Make"' 0 "gmake is GNU Make"

. "../teardown.sh"
echo "All make gmake-alias tests passed!"
