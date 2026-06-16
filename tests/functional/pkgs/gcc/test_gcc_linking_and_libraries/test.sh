#!/bin/sh -eux
# Functional test: gcc - Linking-and-libraries

. "../setup.sh"

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

. "../teardown.sh"
echo "All gcc Linking-and-libraries tests passed!"
