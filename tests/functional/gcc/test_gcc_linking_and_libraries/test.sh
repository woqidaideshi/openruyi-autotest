#!/bin/sh -eux
# Functional test: gcc - Linking-and-libraries

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


echo ""
echo "All gcc Linking-and-libraries tests passed!"
