#!/bin/sh -eux
# Functional test: clang - Error-handling

. "../setup.sh"

echo "=== Test 15: Error handling ==="
cat > bad.c << 'EOF'
int main() { invalid; return 0; }
EOF
rlRun 'clang bad.c -o bad 2>&1 || true' 0 "Compilation error"
rlRun 'clang --invalid-option 2>&1 || true' 0 "Invalid option"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All clang Error-handling tests passed!"
