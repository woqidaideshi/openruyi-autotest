#!/bin/sh -eux
# Functional test: gcc - Special-features

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


echo ""
echo "All gcc Special-features tests passed!"
