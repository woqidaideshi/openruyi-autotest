#!/bin/sh -eux
# Functional test: gcc - C---compilation

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

echo "=== Test 2: C++ compilation ==="
# Simple C++ test (no iostream to avoid slow header compilation on riscv64)
cat > hello2.cpp << 'EOF'
int main() { return 0; }
EOF
rlRun 'g++ hello2.cpp -o hellocpp' 0 "Compile hello.cpp"
rlRun 'g++ -std=c++11 hello2.cpp -o hellocpp11' 0 "Compile with C++11 standard"


echo ""
echo "All gcc C---compilation tests passed!"
