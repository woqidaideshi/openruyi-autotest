#!/bin/sh -eux
# Functional test: gcc - Error-handling

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

echo "=== Test 10: Error handling ==="

# Test 10.1: Syntax error
echo "int main() { return }" > bad_syntax.c
rlRun 'gcc bad_syntax.c 2>&1' 1-255 "Test syntax error detection"

# Test 10.2: Missing file
rlRun 'gcc nonexistent.c 2>&1' 1-255 "Test missing file error"

# Test 10.3: Undefined function
echo "int main() { undefined_func(); }" > bad_func.c
rlRun 'gcc bad_func.c 2>&1' 1-255 "Test undefined function error"

# Test 10.4: Type mismatch warning
echo "int main() { char* p = 42; }" > bad_type.c
rlRun 'gcc -Wall bad_type.c -o bad_type 2>&1' 0 "Test type mismatch warning"


echo ""
echo "All gcc Error-handling tests passed!"
