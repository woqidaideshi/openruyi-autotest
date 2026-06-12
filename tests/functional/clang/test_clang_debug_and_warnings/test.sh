#!/bin/sh -eux
# Functional test: clang - Debug-and-warnings

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

echo "=== Test 5: Debug and warnings ==="
rlRun 'clang -g -c hello.c -o hello_g.o' 0 "Debug symbols"
rlRun 'clang -Wall -c hello.c -o hello_Wall.o' 0 "-Wall warnings"
rlRun 'clang -Wextra -c hello.c -o hello_Wextra.o' 0 "-Wextra warnings"
rlRun 'clang -Werror -c hello.c -o hello_Werror.o' 0 "-Werror"


echo ""
echo "All clang Debug-and-warnings tests passed!"
