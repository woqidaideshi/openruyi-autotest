#!/bin/sh -eux
# Functional test: gcc - Basic-C-compilation

. "../setup.sh"

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

. "../teardown.sh"
echo "All gcc Basic-C-compilation tests passed!"
