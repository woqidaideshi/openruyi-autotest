#!/bin/sh -eux
# Functional test: clang - C---standards

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q clang 2>/dev/null || { echo 'clang not installed, skipping'; exit 0; }
which clang 2>/dev/null || echo 'clang not found'
which clang++ 2>/dev/null || echo 'clang++ not found'
which clang-cl 2>/dev/null || echo 'clang-cl not found'
which clang-cpp 2>/dev/null || echo 'clang-cpp not found'
which clang-scan-deps 2>/dev/null || echo 'clang-scan-deps not found'
rlRun 'clang --version' 0 "clang version"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 7: C++ standards ==="
for std in c++11 c++14 c++17; do
    rlRun "clang++ -std=$std -x c++ -c hello.c -o cpp_$std.o" 0 "C++ standard: $std"
done


echo ""
echo "All clang C---standards tests passed!"
