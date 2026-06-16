#!/bin/sh -eux
# Functional test: grep - Basic-pattern-matching

. "../setup.sh"

echo "=== Test 1: Basic pattern matching ==="

# Test 1.1: Simple grep
rlRun 'grep Hello test1.txt' 0 "Basic grep for Hello"
rlRun 'test $(grep Hello test1.txt | wc -l) -ge 2' 0 "Verify multiple matches"

# Test 1.2: Pipe input
rlRun 'echo "hello pipe" | grep hello' 0 "Grep from pipe"

# Test 1.3: Multiple files
rlRun 'grep Hello test1.txt test2.txt' 0 "Grep across multiple files"

. "../teardown.sh"
echo "All grep Basic-pattern-matching tests passed!"
