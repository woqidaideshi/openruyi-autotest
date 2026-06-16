#!/bin/sh -eux
# Functional test: grep - Multiple-patterns---e---f

. "../setup.sh"

echo "=== Test 12: Multiple patterns (-e, -f) ==="

# Test 12.1: Multiple -e patterns
rlRun 'grep -e Hello -e apple test1.txt test2.txt' 0 "Multiple patterns with -e"

# Test 12.2: Patterns from file
echo "Hello" > patterns.txt
echo "apple" >> patterns.txt
rlRun 'grep -f patterns.txt test1.txt test2.txt' 0 "Patterns from file with -f"

# Test 12.3: Max count
rlRun 'test $(grep -m1 Hello test1.txt | wc -l) -eq 1' 0 "Max count: stop after first match"

. "../teardown.sh"
echo "All grep Multiple-patterns---e---f tests passed!"
