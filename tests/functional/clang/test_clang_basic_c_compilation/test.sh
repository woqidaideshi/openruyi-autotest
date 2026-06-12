#!/bin/sh -eux
# Functional test: clang - Basic-C-compilation

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q clang 2>/dev/null || { echo 'clang not installed, skipping'; exit 0; }
which clang 2>/dev/null || echo 'clang not found'
which clang++ 2>/dev/null || echo 'clang++ not found'
which clang-cl 2>/dev/null || echo 'clang-cl not found'
which clang-cpp 2>/dev/null || echo 'clang-cpp not found'
which clang-scan-deps 2>/dev/null || echo 'clang-scan-deps not found'
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
