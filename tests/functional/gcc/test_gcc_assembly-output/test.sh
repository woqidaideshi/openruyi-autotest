#!/bin/sh -eux
# Functional test: gcc - Assembly-output

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

echo "=== Test 5: Assembly output ==="

# Test 5.1: Generate assembly (-S)
rlRun 'gcc -S hello.c -o hello.s' 0 "Generate assembly with -S"
rlRun 'grep -q "main:" hello.s' 0 "Check main label in assembly"

# Test 5.2: Assemble .s file to object
rlRun 'as hello.s -o hello_obj.o' 0 "Assemble to object file"


echo ""
echo "All gcc Assembly-output tests passed!"
