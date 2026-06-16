#!/bin/sh -eux
# Functional test: grep - Fixed-strings---F

. "../setup.sh"

echo "=== Test 8: Fixed strings (-F) ==="

# Test 8.1: Fixed string (no regex interpretation)
rlRun 'grep -F "Special chars: *.[]^$" test1.txt' 0 "Fixed string with special chars"
rlRun 'grep -F "*.[]" test1.txt' 0 "Fixed string: no regex meta-char interpretation"

# Test 8.2: fgrep equivalent
rlRun 'fgrep "Special chars" test1.txt' 0 "fgrep equivalent to grep -F"

. "../teardown.sh"
echo "All grep Fixed-strings---F tests passed!"
