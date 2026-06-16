#!/bin/sh -eux
# Functional test: clang - Basic-C-compilation

. "../setup.sh"

echo "=== Test 1: Basic C compilation ==="
cat > hello.c << 'EOF'
#include <stdio.h>
int main() { printf("Hello Clang\n"); return 0; }
EOF
rlRun 'clang hello.c -o hello' 0 "Compile hello.c"
rlRun './hello' 0 "Run compiled binary"
rlRun 'file hello | grep -i elf' 0 "Output is ELF binary"

. "../teardown.sh"
echo "All clang Basic-C-compilation tests passed!"
