#!/bin/sh -eux
# Functional test: grep - Extended-regex---E

. "../setup.sh"

echo "=== Test 7: Extended regex (-E) ==="

# Test 7.1: Extended regex alternation
rlRun 'grep -E "apple|banana" test2.txt' 0 "Extended regex with alternation"

# Test 7.2: Extended regex with quantifiers
rlRun 'grep -E "[0-9]+" test1.txt' 0 "Extended regex: digit quantifier"
rlRun 'test $(grep -E "[0-9]+" test1.txt | wc -l) -ge 1' 0 "Verify digit match count"

# Test 7.3: egrep equivalent
rlRun 'egrep "apple|banana" test2.txt' 0 "egrep equivalent to grep -E"

. "../teardown.sh"
echo "All grep Extended-regex---E tests passed!"
