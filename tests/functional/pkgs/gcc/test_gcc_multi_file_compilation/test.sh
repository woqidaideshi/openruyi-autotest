#!/bin/sh -eux
# Functional test: gcc - Multi-file-compilation

. "../setup.sh"

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

. "../teardown.sh"
echo "All gcc Multi-file-compilation tests passed!"
