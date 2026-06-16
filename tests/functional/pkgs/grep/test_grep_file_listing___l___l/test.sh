#!/bin/sh -eux
# Functional test: grep - File-listing---l---L

. "../setup.sh"

echo "=== Test 11: File listing (-l, -L) ==="

# Test 11.1: Files with matches
rlRun 'grep -l Hello *.txt' 0 "List files with matches"

# Test 11.2: Files without matches
# Create a file without "Hello"
echo "nothing here" > empty_test.txt
rlRun 'grep -L Hello *.txt' 0 "List files without matches"

. "../teardown.sh"
echo "All grep File-listing---l---L tests passed!"
