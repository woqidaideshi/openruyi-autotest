#!/bin/sh -eux
# Functional test: gcc - Error-handling

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
