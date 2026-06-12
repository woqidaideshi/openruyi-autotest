#!/bin/sh -eux
# Functional test: gcc - Basic-C-compilation

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
