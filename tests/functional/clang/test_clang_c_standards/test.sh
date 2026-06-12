#!/bin/sh -eux
# Functional test: clang - C-standards

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

echo "=== Test 6: C standards ==="
for std in c89 c99 c11 c17; do
    rlRun "clang -std=$std -c hello.c -o hello_$std.o" 0 "C standard: $std"
done


echo ""
echo "All clang C-standards tests passed!"
