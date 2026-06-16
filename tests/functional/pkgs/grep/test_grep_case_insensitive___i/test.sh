#!/bin/sh -eux
# Functional test: grep - Case-insensitive---i

. "../setup.sh"

echo "=== Test 2: Case insensitive (-i) ==="

# Test 2.1: Case insensitive match
rlRun 'grep -i hello test1.txt' 0 "Case insensitive grep"
rlRun 'test $(grep -i hello test1.txt | wc -l) -ge 2' 0 "Verify case insensitive matches"

# Test 2.2: Case sensitive (default)
rlRun 'grep hello test1.txt' 1 "Case sensitive: lowercase only matches lowercase" || true

. "../teardown.sh"
echo "All grep Case-insensitive---i tests passed!"
