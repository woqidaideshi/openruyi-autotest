#!/bin/sh -eux
# Functional test: gcc - Basic-C-compilation

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


echo ""
echo "All gcc Basic-C-compilation tests passed!"
