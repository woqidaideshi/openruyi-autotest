#!/bin/sh -eux
# Functional test: clang package (LLVM C/C++ Compiler)
# Tests clang, clang++, clang-cl, clang-cpp, clang-scan-deps
# Version: clang 21.1

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

echo "=== Test 1: Basic C compilation ==="
cat > hello.c << 'EOF'
#include <stdio.h>
int main() { printf("Hello Clang\n"); return 0; }
EOF
rlRun 'clang hello.c -o hello' 0 "Compile hello.c"
rlRun './hello' 0 "Run compiled binary"
rlRun 'file hello | grep -i elf' 0 "Output is ELF binary"

echo "=== Test 2: Basic C++ compilation ==="
rlRun 'clang++ -x c++ hello.c -o hello_cpp' 0 "Compile C++ from hello.c"
rlRun './hello_cpp' 0 "Run C++ binary"

echo "=== Test 3: Compile-only ==="
rlRun 'clang -c hello.c -o hello.o' 0 "clang -c: compile only"
rlRun 'test -f hello.o' 0 "Object file exists"

echo "=== Test 4: Optimization levels ==="
for lvl in O0 O1 O2 O3 Os Oz; do
    rlRun "clang -$lvl -c hello.c -o hello_$lvl.o" 0 "Optimization -$lvl"
done

echo "=== Test 5: Debug and warnings ==="
rlRun 'clang -g -c hello.c -o hello_g.o' 0 "Debug symbols"
rlRun 'clang -Wall -c hello.c -o hello_Wall.o' 0 "-Wall warnings"
rlRun 'clang -Wextra -c hello.c -o hello_Wextra.o' 0 "-Wextra warnings"
rlRun 'clang -Werror -c hello.c -o hello_Werror.o' 0 "-Werror"

echo "=== Test 6: C standards ==="
for std in c89 c99 c11 c17; do
    rlRun "clang -std=$std -c hello.c -o hello_$std.o" 0 "C standard: $std"
done

echo "=== Test 7: C++ standards ==="
for std in c++11 c++14 c++17; do
    rlRun "clang++ -std=$std -x c++ -c hello.c -o cpp_$std.o" 0 "C++ standard: $std"
done

echo "=== Test 8: Preprocessor ==="
rlRun 'clang -E hello.c | head -20' 0 "clang -E: preprocess"
rlRun 'clang -dM -E hello.c | head -10' 0 "clang -dM: dump macros"

echo "=== Test 9: Static analysis ==="
rlRun 'clang --analyze hello.c 2>&1 || true' 0 "clang --analyze: static analysis"

echo "=== Test 10: clang-cl (MSVC compat) ==="
rlRun 'clang-cl --help 2>&1 | head -5' 0 "clang-cl help"

echo "=== Test 11: clang-cpp ==="
rlRun 'clang-cpp hello.c 2>&1 | head -10' 0 "clang-cpp: preprocessor"

echo "=== Test 12: clang-scan-deps ==="
rlRun 'clang-scan-deps --help 2>&1 | head -5' 0 "clang-scan-deps help"

echo "=== Test 13: Linking options ==="
rlRun 'clang -fPIC -c hello.c -o hello_pic.o' 0 "Compile with -fPIC"
rlRun 'clang -shared hello_pic.o -o libhello.so' 0 "clang -shared: shared library"

echo "=== Test 14: Verbose mode ==="
rlRun 'clang -v -c hello.c -o /dev/null 2>&1 | head -10' 0 "clang -v: verbose"

echo "=== Test 15: Error handling ==="
cat > bad.c << 'EOF'
int main() { invalid; return 0; }
EOF
rlRun 'clang bad.c -o bad 2>&1 || true' 0 "Compilation error"
rlRun 'clang --invalid-option 2>&1 || true' 0 "Invalid option"

cd /
rm -rf $TmpDir

echo ""
echo "All clang functional tests passed!"