#!/bin/sh -eux
# Functional test: clang - C-standards

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

echo "=== Test 6: C standards ==="
for std in c89 c99 c11 c17; do
    rlRun "clang -std=$std -c hello.c -o hello_$std.o" 0 "C standard: $std"
done


echo ""
echo "All clang C-standards tests passed!"
