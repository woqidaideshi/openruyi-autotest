#!/bin/sh -eux
# Functional test: gxx - Include-paths

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q gcc-c++' 0 "Check gcc-c++ is installed"
rlRun 'which g++' 0 "Check g++ command available"
rlRun 'which c++' 0 "Check c++ command available"
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
