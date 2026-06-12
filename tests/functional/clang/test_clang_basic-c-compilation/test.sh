#!/bin/sh -eux
# Functional test: clang - Basic-C-compilation

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q clang' 0 "Check clang installed"
rlRun 'which clang' 0 "Check clang available"
rlRun 'which clang++' 0 "Check clang++ available"
rlRun 'which clang-cl' 0 "Check clang-cl available"
rlRun 'which clang-cpp' 0 "Check clang-cpp available"
rlRun 'which clang-scan-deps' 0 "Check clang-scan-deps available"
rlRun 'clang --version' 0 "clang version"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 1: Basic C compilation ==="
cat > hello.c << 'EOF'
#include <stdio.h>
int main() { printf("Hello Clang\n"); return 0; }
EOF
rlRun 'clang hello.c -o hello' 0 "Compile hello.c"
rlRun './hello' 0 "Run compiled binary"
rlRun 'file hello | grep -i elf' 0 "Output is ELF binary"


echo ""
echo "All clang Basic-C-compilation tests passed!"
