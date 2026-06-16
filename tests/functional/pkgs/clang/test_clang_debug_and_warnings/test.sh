#!/bin/sh -eux
# Functional test: clang - Debug-and-warnings

. "../setup.sh"

echo "=== Test 5: Debug and warnings ==="
rlRun 'clang -g -c hello.c -o hello_g.o' 0 "Debug symbols"
rlRun 'clang -Wall -c hello.c -o hello_Wall.o' 0 "-Wall warnings"
rlRun 'clang -Wextra -c hello.c -o hello_Wextra.o' 0 "-Wextra warnings"
rlRun 'clang -Werror -c hello.c -o hello_Werror.o' 0 "-Werror"

. "../teardown.sh"
echo "All clang Debug-and-warnings tests passed!"
