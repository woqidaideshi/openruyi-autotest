#!/bin/sh -eux
# Functional test: grep - Context-lines---A---B---C

. "../setup.sh"

echo "=== Test 10: Context lines (-A, -B, -C) ==="

# Test 10.1: After context
rlRun 'grep -A1 "Hello World" test1.txt' 0 "Context: 1 line after match"

# Test 10.2: Before context
rlRun 'grep -B1 "Hello Linux" test1.txt' 0 "Context: 1 line before match"

# Test 10.3: Both context
rlRun 'grep -C1 "Hello World" test1.txt' 0 "Context: 1 line before and after"

. "../teardown.sh"
echo "All grep Context-lines---A---B---C tests passed!"
