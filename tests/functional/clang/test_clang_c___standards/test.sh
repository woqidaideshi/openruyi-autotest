#!/bin/sh -eux
# Functional test: clang - C---standards

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q clang' 0 "Check clang installed"
rlRun 'which clang' 0 "Check clang available"
rlRun 'which clang++' 0 "Check clang++ available"
rlRun 'which clang-cl' 0 "Check clang-cl available"
rlRun 'which clang-cpp' 0 "Check clang-cpp available"
rlRun 'which clang-scan-deps' 0 "Check clang-scan-deps available"
rlRun 'clang --version' 0 "clang version"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 7: C++ standards ==="
for std in c++11 c++14 c++17; do
    rlRun "clang++ -std=$std -x c++ -c hello.c -o cpp_$std.o" 0 "C++ standard: $std"
done


echo ""
echo "All clang C---standards tests passed!"
