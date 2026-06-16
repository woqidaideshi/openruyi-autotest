#!/bin/sh -eux
# Functional test: grep - Count-and-line-numbers---c---n

. "../setup.sh"

echo "=== Test 5: Count and line numbers (-c, -n) ==="

# Test 5.1: Count matches
rlRun 'grep -c Hello test1.txt' 0 "Count matches with -c"
rlRun 'test $(grep -c Hello test1.txt) -ge 2' 0 "Verify count >= 2"

# Test 5.2: Line numbers
rlRun 'grep -n Hello test1.txt' 0 "Show line numbers with -n"
rlRun 'grep -n Hello test1.txt | grep -q "^[0-9]:"' 0 "Verify line number format"

. "../teardown.sh"
echo "All grep Count-and-line-numbers---c---n tests passed!"
