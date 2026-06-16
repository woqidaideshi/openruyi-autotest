#!/bin/sh -eux
# Functional test: gcc - C---compilation

. "../setup.sh"

echo "=== Test 2: C++ compilation ==="
# Simple C++ test (no iostream to avoid slow header compilation on riscv64)
cat > hello2.cpp << 'EOF'
int main() { return 0; }
EOF
rlRun 'g++ hello2.cpp -o hellocpp' 0 "Compile hello.cpp"
rlRun 'g++ -std=c++11 hello2.cpp -o hellocpp11' 0 "Compile with C++11 standard"

. "../teardown.sh"
echo "All gcc C---compilation tests passed!"
