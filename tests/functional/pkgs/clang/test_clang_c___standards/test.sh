#!/bin/sh -eux
# Functional test: clang - C---standards

. "../setup.sh"

echo "=== Test 7: C++ standards ==="
for std in c++11 c++14 c++17; do
    rlRun "clang++ -std=$std -x c++ -c hello.c -o cpp_$std.o" 0 "C++ standard: $std"
done

. "../teardown.sh"
echo "All clang C---standards tests passed!"
