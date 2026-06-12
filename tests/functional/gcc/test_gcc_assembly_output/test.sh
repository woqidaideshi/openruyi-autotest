#!/bin/sh -eux
# Functional test: gcc - Assembly-output

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

echo "=== Test 5: Assembly output ==="

# Test 5.1: Generate assembly (-S)
rlRun 'gcc -S hello.c -o hello.s' 0 "Generate assembly with -S"
rlRun 'grep -q "main:" hello.s' 0 "Check main label in assembly"

# Test 5.2: Assemble .s file to object
rlRun 'as hello.s -o hello_obj.o' 0 "Assemble to object file"


echo ""
echo "All gcc Assembly-output tests passed!"
