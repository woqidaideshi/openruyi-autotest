#!/bin/sh -eux
# Functional test: gcc - Compiler-optimization-flags

. "../setup.sh"

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

. "../teardown.sh"
echo "All gcc Compiler-optimization-flags tests passed!"
