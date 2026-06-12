#!/bin/sh -eux
# Functional test: gcc - Code-coverage--gcov

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q gcc' 0 "Check gcc package is installed"
rlRun 'rpm -q gcc-c++' 0 "Check gcc-c++ package is installed"
rlRun 'which gcc' 0 "Check gcc command is available"
rlRun 'which g++' 0 "Check g++ command is available"
rlRun 'which cpp' 0 "Check cpp command is available"
rlRun 'gcc --version' 0 "Get gcc version info"
rlRun 'g++ --version' 0 "Get g++ version info"
TmpDir=$(mktemp -d)
cd $TmpDir

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


echo ""
echo "All gcc Code-coverage--gcov tests passed!"
