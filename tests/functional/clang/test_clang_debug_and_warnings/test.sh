#!/bin/sh -eux
# Functional test: clang - Debug-and-warnings

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

echo "=== Test 5: Debug and warnings ==="
rlRun 'clang -g -c hello.c -o hello_g.o' 0 "Debug symbols"
rlRun 'clang -Wall -c hello.c -o hello_Wall.o' 0 "-Wall warnings"
rlRun 'clang -Wextra -c hello.c -o hello_Wextra.o' 0 "-Wextra warnings"
rlRun 'clang -Werror -c hello.c -o hello_Werror.o' 0 "-Werror"


echo ""
echo "All clang Debug-and-warnings tests passed!"
