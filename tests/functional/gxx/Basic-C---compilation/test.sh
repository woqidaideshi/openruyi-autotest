#!/bin/sh -eux
# Functional test: gxx - Basic-C---compilation

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q gcc-c++' 0 "Check gcc-c++ is installed"
rlRun 'which g++' 0 "Check g++ command available"
rlRun 'which c++' 0 "Check c++ command available"
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
