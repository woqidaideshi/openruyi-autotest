#!/bin/sh -eux
# Functional test: gxx - Basic-C---compilation

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q gcc-c++ 2>/dev/null || { echo 'gcc-c++ not installed, skipping'; exit 0; }
which g++ 2>/dev/null || echo 'g++ not found'
which c++ 2>/dev/null || echo 'c++ not found'
rlRun 'g++ --version' 0 "g++ version info"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 1: Basic C++ compilation ==="
cat > hello.cpp << 'EOF'
int main() { return 42; }
EOF
rlRun 'g++ hello.cpp -o hello' 0 "Compile hello.cpp"
rlRun './hello' 0 "Run compiled binary"
rlRun 'file hello | grep -i elf' 0 "Output is ELF binary"


echo ""
echo "All gxx Basic-C---compilation tests passed!"
