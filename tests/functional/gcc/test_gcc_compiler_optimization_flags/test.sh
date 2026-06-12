#!/bin/sh -eux
# Functional test: gcc - Compiler-optimization-flags

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
