#!/bin/sh -eux
# Functional test: gcc - Warning-flags

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

echo "=== Test 7: Warning flags ==="

cat > warn.c << 'EOF'
int main() {
    int x;
    return x;
}
EOF

# Test 7.1: Compile with -Wall
rlRun 'gcc -Wall warn.c -o warn_test 2>&1' 0 "Compile with -Wall warnings enabled"

# Test 7.2: Compile with -Werror (warnings as errors)
rlRun 'gcc -Wall -Werror hello.c -o hello_werr' 0 "Compile with -Werror"

# Test 7.3: Compile with -pedantic
rlRun 'gcc -pedantic hello.c -o hello_pedantic' 0 "Compile with -pedantic"


echo ""
echo "All gcc Warning-flags tests passed!"
