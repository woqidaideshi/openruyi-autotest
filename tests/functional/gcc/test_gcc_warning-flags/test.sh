#!/bin/sh -eux
# Functional test: gcc - Warning-flags

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
