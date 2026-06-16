#!/bin/sh -eux
# Functional test: grep - Only-matching-and-quiet---o---q

. "../setup.sh"

echo "=== Test 9: Only matching and quiet (-o, -q) ==="

# Test 9.1: Only matching parts
rlRun 'echo "abc123def456" | grep -o "[0-9]\+"' 0 "Only matching: digits only"

# Test 9.2: Quiet mode (exit status only)
rlRun 'grep -q Hello test1.txt' 0 "Quiet mode: pattern found"
rlRun 'grep -q NONEXISTENT test1.txt' 1 "Quiet mode: pattern not found" || true

. "../teardown.sh"
echo "All grep Only-matching-and-quiet---o---q tests passed!"
