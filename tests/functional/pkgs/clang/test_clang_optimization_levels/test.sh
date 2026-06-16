#!/bin/sh -eux
# Functional test: clang - Optimization-levels

. "../setup.sh"

echo "=== Test 4: Optimization levels ==="
for lvl in O0 O1 O2 O3 Os Oz; do
    rlRun "clang -$lvl -c hello.c -o hello_$lvl.o" 0 "Optimization -$lvl"
done

. "../teardown.sh"
echo "All clang Optimization-levels tests passed!"
