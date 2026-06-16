#!/bin/sh -eux
# Functional test: grep - Invert-match---v

. "../setup.sh"

echo "=== Test 3: Invert match (-v) ==="

# Test 3.1: Invert match
rlRun 'grep -v Hello test1.txt' 0 "Invert match: exclude Hello"
rlRun 'grep -v Hello test1.txt | grep -c World' 0 "Verify inverted output contains other lines"

. "../teardown.sh"
echo "All grep Invert-match---v tests passed!"
