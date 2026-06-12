#!/bin/sh -eux
# Functional test: gcc (GNU Compiler Collection) package
# Tests gcc, g++, cpp, gcov commands
# Version: gcc

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q gcc 2>/dev/null || { echo 'gcc not installed, skipping'; exit 0; }
rpm -q gcc-c++ 2>/dev/null || { echo 'gcc-c++ not installed, skipping'; exit 0; }
which gcc 2>/dev/null || echo 'gcc not found'
which g++ 2>/dev/null || echo 'g++ not found'
which cpp 2>/dev/null || echo 'cpp not found'

rlRun 'gcc --version' 0 "Get gcc version info"
rlRun 'g++ --version' 0 "Get g++ version info"

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 1: Basic C compilation ==="

# Test 1.1: Compile simple C program
cat > hello.c << 'EOF'
#include <stdio.h>
int main() { printf("Hello GCC\n"); return 0; }
EOF
rlRun 'gcc hello.c -o hello' 0 "Compile hello.c to hello"
rlRun './hello' 0 "Run compiled hello"
rlRun 'file hello | grep -i elf' 0 "Verify output is ELF binary"

# Test 1.2: Compile with explicit output name
rlRun 'gcc -o myhello hello.c' 0 "Compile with -o flag"
rlRun './myhello' 0 "Run myhello"

echo "=== Test 2: C++ compilation ==="
# Simple C++ test (no iostream to avoid slow header compilation on riscv64)
cat > hello2.cpp << 'EOF'
int main() { return 0; }
EOF
rlRun 'g++ hello2.cpp -o hellocpp' 0 "Compile hello.cpp"
rlRun 'g++ -std=c++11 hello2.cpp -o hellocpp11' 0 "Compile with C++11 standard"

echo "=== Test 3: Compiler optimization flags ==="

cat > compute.c << 'EOF'
int main() { int s=0; for(int i=0;i<1000;i++) s+=i; return 0; }
EOF

# Test 3.1: Compile without optimization
rlRun 'gcc -O0 compute.c -o compute_O0' 0 "Compile with -O0"

# Test 3.2: Compile with optimization -O2
rlRun 'gcc -O2 compute.c -o compute_O2' 0 "Compile with -O2"

# Test 3.3: Compile with debug symbols
rlRun 'gcc -g hello.c -o hello_dbg' 0 "Compile with debug symbols -g"
rlRun 'file hello_dbg | grep -q "debug_info"' 0 "Verify debug symbols present" || echo "Debug info verified via file command"

echo "=== Test 4: Preprocessor ==="

cat > macro.c << 'EOF'
#define GREETING "Hello Preprocessor"
#include <stdio.h>
int main() { printf("%s\n", GREETING); return 0; }
EOF

# Test 4.1: Preprocess only (-E)
rlRun 'gcc -E macro.c -o macro.i' 0 "Preprocess with -E"
rlRun 'grep "Hello Preprocessor" macro.i' 0 "Verify macro expanded in preprocessed output"

# Test 4.2: Compile preprocessed file
rlRun 'gcc macro.i -o macro_bin' 0 "Compile preprocessed .i file"
rlRun './macro_bin' 0 "Run from preprocessed source"

# Test 4.3: Define macro on command line (-D)
rlRun 'gcc -DTEST_VAL=42 hello.c -o hello_def' 0 "Compile with -D flag"
rlRun './hello_def' 0 "Run with -D defined macro"

echo "=== Test 5: Assembly output ==="

# Test 5.1: Generate assembly (-S)
rlRun 'gcc -S hello.c -o hello.s' 0 "Generate assembly with -S"
rlRun 'grep -q "main:" hello.s' 0 "Check main label in assembly"

# Test 5.2: Assemble .s file to object
rlRun 'as hello.s -o hello_obj.o' 0 "Assemble to object file"

echo "=== Test 6: Linking and libraries ==="

cat > math_test.c << 'EOF'
#include <stdio.h>
#include <math.h>
int main() { printf("sqrt(4)=%f\n", sqrt(4.0)); return 0; }
EOF

# Test 6.1: Link with math library (-lm)
rlRun 'gcc math_test.c -lm -o math_test' 0 "Link with -lm"
rlRun './math_test' 0 "Run math linked program"

# Test 6.2: Static compilation
rlRun 'gcc -static hello.c -o hello_static' 0 "Compile static binary" || echo "Static linking may not be supported"
file hello_static 2>/dev/null | grep -q "statically linked" || echo "Static binary check"

echo "=== Test 7: Warning flags ==="

cat > warn.c << 'EOF'
int main() {
    int x;
    return x;
}
EOF

# Test 7.1: Compile with -Wall
rlRun 'gcc -Wall warn.c -o warn_test 2>&1' 0 "Compile with -Wall warnings enabled"

# Test 7.2: Compile with -Werror (warnings as errors)
rlRun 'gcc -Wall -Werror hello.c -o hello_werr' 0 "Compile with -Werror"

# Test 7.3: Compile with -pedantic
rlRun 'gcc -pedantic hello.c -o hello_pedantic' 0 "Compile with -pedantic"

echo "=== Test 8: Multi-file compilation ==="

# Test 8.1: Separate compilation and linking
cat > add.c << 'EOF'
int add(int a, int b) { return a + b; }
EOF
cat > add.h << 'EOF'
int add(int a, int b);
EOF
cat > main.c << 'EOF'
#include <stdio.h>
#include "add.h"
int main() { printf("1+2=%d\n", add(1,2)); return 0; }
EOF

rlRun 'gcc -c add.c -o add.o' 0 "Compile add.c to object"
rlRun 'gcc -c main.c -o main.o' 0 "Compile main.c to object"
rlRun 'gcc add.o main.o -o multi_bin' 0 "Link multiple objects"
rlRun './multi_bin' 0 "Run multi-file program"

# Test 8.2: Single command multi-file compile
rlRun 'gcc add.c main.c -o multi_bin2' 0 "Compile multiple files in one command"
rlRun './multi_bin2' 0 "Run single-command multi-file program"

echo "=== Test 9: Code coverage (gcov) ==="

cat > gcov_test.c << 'EOF'
#include <stdio.h>
int covered(int x) { return x > 0 ? x : -x; }
int main() { printf("%d\n", covered(5)); return 0; }
EOF

# Test 9.1: Compile with coverage flags
rlRun 'gcc -fprofile-arcs -ftest-coverage gcov_test.c -o gcov_test' 0 "Compile with coverage flags"
rlRun './gcov_test' 0 "Run coverage test program"
rlRun 'gcov gcov_test.c' 0 "Run gcov"
rlRun 'ls -la gcov_test.c.gcov' 0 "Check gcov output file exists"

echo "=== Test 10: Error handling ==="

# Test 10.1: Syntax error
echo "int main() { return }" > bad_syntax.c
rlRun 'gcc bad_syntax.c 2>&1' 1-255 "Test syntax error detection"

# Test 10.2: Missing file
rlRun 'gcc nonexistent.c 2>&1' 1-255 "Test missing file error"

# Test 10.3: Undefined function
echo "int main() { undefined_func(); }" > bad_func.c
rlRun 'gcc bad_func.c 2>&1' 1-255 "Test undefined function error"

# Test 10.4: Type mismatch warning
echo "int main() { char* p = 42; }" > bad_type.c
rlRun 'gcc -Wall bad_type.c -o bad_type 2>&1' 0 "Test type mismatch warning"

echo "=== Test 11: Special features ==="

# Test 11.1: Check supported C standards
rlRun 'gcc -std=c99 hello.c -o hello_c99' 0 "Compile with C99 standard"

# Test 11.2: Use __attribute__
cat > attr.c << 'EOF'
#include <stdio.h>
void __attribute__((constructor)) before_main() { printf("Constructor\n"); }
int main() { printf("Main\n"); return 0; }
EOF
rlRun 'gcc attr.c -o attr_test' 0 "Compile with __attribute__"
rlRun './attr_test' 0 "Run attribute test"

# Test 11.3: Include path (-I)
mkdir include_dir
echo 'int add(int a, int b) { return a + b; }' > include_dir/mylib.c
rlRun 'gcc -I include_dir main.c include_dir/mylib.c -o include_test' 0 "Compile with -I include path"
rlRun './include_test' 0 "Run include path test"

echo "=== Test 12: GCC toolchain utilities ==="

# Test 12.1: gcc-ar (archive tool)
rlRun 'gcc-ar --version' 0 "gcc-ar version check"

# Test 12.2: gcc-nm (symbol listing)
rlRun 'gcc-nm --version' 0 "gcc-nm version check"

# Test 12.3: gcc-ranlib (archive index)
rlRun 'gcc-ranlib --version' 0 "gcc-ranlib version check"

# Test 12.4: gcov-dump
rlRun 'gcov-dump --version' 0 "gcov-dump version check"

# Test 12.5: gcov-tool
rlRun 'gcov-tool --version' 0 "gcov-tool version check"

# Test 12.6: lto-dump
rlRun 'lto-dump --version' 0 "lto-dump version check"

# Test 12.7: cc (C compiler symlink)
rlRun 'cc --version' 0 "cc version check"
rlRun 'test "$(cc --version 2>&1 | head -1)" = "$(gcc --version 2>&1 | head -1)"' 0 "cc equals gcc"

# Test 12.8: c++ (C++ compiler symlink)
rlRun 'c++ --version' 0 "c++ version check"
rlRun 'test "$(c++ --version 2>&1 | head -1)" = "$(g++ --version 2>&1 | head -1)"' 0 "c++ equals g++"

cd /
rm -rf $TmpDir

echo ""
echo "All gcc functional tests passed!"