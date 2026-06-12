#!/bin/sh -eux
# Functional test: gcc - Preprocessor

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

echo "=== Test 4: Preprocessor ==="

cat > macro.c << 'EOF'
#define GREETING "Hello Preprocessor"
#include <stdio.h>
int main() { printf("%s\n", GREETING); return 0; }
EOF

# Test 4.1: Preprocess only (-E)
rlRun 'gcc -E macro.c -o macro.i' 0 "Preprocess with -E"
rlRun 'grep "Hello Preprocessor" macro.i' 0 "Verify macro expanded in preprocessed output"

# Test 4.2: Compile preprocessed file
rlRun 'gcc macro.i -o macro_bin' 0 "Compile preprocessed .i file"
rlRun './macro_bin' 0 "Run from preprocessed source"

# Test 4.3: Define macro on command line (-D)
rlRun 'gcc -DTEST_VAL=42 hello.c -o hello_def' 0 "Compile with -D flag"
rlRun './hello_def' 0 "Run with -D defined macro"


echo ""
echo "All gcc Preprocessor tests passed!"
