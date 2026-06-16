#!/bin/sh -eux
# Functional test: grep - Recursive-search---r

. "../setup.sh"

echo "=== Test 6: Recursive search (-r) ==="

# Test 6.1: Recursive search
rlRun 'grep -r nested subdir/' 0 "Recursive grep in subdirectory"
rlRun 'grep -rl hello subdir/' 0 "Recursive list files with matches"

# Test 6.2: Include/exclude patterns
rlRun 'grep -r --include="*.txt" hello .' 0 "Recursive with --include filter"

. "../teardown.sh"
echo "All grep Recursive-search---r tests passed!"
