#!/bin/sh -eux
# Functional test: gcc - C---compilation

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

echo "=== Test 2: C++ compilation ==="
# Simple C++ test (no iostream to avoid slow header compilation on riscv64)
cat > hello2.cpp << 'EOF'
int main() { return 0; }
EOF
rlRun 'g++ hello2.cpp -o hellocpp' 0 "Compile hello.cpp"
rlRun 'g++ -std=c++11 hello2.cpp -o hellocpp11' 0 "Compile with C++11 standard"


echo ""
echo "All gcc C---compilation tests passed!"
