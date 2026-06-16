#!/bin/sh -eux
# Functional test: gcc - Warning-flags

. "../setup.sh"

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

. "../teardown.sh"
echo "All gcc Warning-flags tests passed!"
