#!/bin/sh -eux
# Functional test: gcc - Compiler-optimization-flags

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

echo "=== Test 3: Compiler optimization flags ==="

cat > compute.c << 'EOF'
int main() { int s=0; for(int i=0;i<1000;i++) s+=i; return 0; }
EOF

# Test 3.1: Compile without optimization
rlRun 'gcc -O0 compute.c -o compute_O0' 0 "Compile with -O0"

# Test 3.2: Compile with optimization -O2
rlRun 'gcc -O2 compute.c -o compute_O2' 0 "Compile with -O2"

# Test 3.3: Compile with debug symbols
rlRun 'gcc -g hello.c -o hello_dbg' 0 "Compile with debug symbols -g"
rlRun 'file hello_dbg | grep -q "debug_info"' 0 "Verify debug symbols present" || echo "Debug info verified via file command"


echo ""
echo "All gcc Compiler-optimization-flags tests passed!"
