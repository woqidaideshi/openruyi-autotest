#!/bin/sh -eux
# Functional test: gxx - Include-paths

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q gcc-c++ 2>/dev/null || { echo 'gcc-c++ not installed, skipping'; exit 0; }
which g++ 2>/dev/null || echo 'g++ not found'
which c++ 2>/dev/null || echo 'c++ not found'
rlRun 'g++ --version' 0 "g++ version info"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 10: Include paths ==="
mkdir inc
echo '#define TEST_VAL 42' > inc/test.h
cat > inc_test.cpp << 'EOF'
#include "test.h"
int main() { return TEST_VAL; }
EOF
rlRun 'g++ -I inc inc_test.cpp -o inc_test' 0 "g++ -I: include path"


echo ""
echo "All gxx Include-paths tests passed!"
