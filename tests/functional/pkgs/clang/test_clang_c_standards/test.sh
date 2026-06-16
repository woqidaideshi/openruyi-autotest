#!/bin/sh -eux
# Functional test: clang - C-standards

. "../setup.sh"

echo "=== Test 6: C standards ==="
for std in c89 c99 c11 c17; do
    rlRun "clang -std=$std -c hello.c -o hello_$std.o" 0 "C standard: $std"
done

. "../teardown.sh"
echo "All clang C-standards tests passed!"
