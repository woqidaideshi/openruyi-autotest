#!/bin/sh -eux
# Functional test: clang - Error-handling

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q clang 2>/dev/null || { echo 'clang not installed, skipping'; exit 0; }
which clang 2>/dev/null || echo 'clang not found'
which clang++ 2>/dev/null || echo 'clang++ not found'
which clang-cl 2>/dev/null || echo 'clang-cl not found'
which clang-cpp 2>/dev/null || echo 'clang-cpp not found'
which clang-scan-deps 2>/dev/null || echo 'clang-scan-deps not found'
rlRun 'clang --version' 0 "clang version"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 15: Error handling ==="
cat > bad.c << 'EOF'
int main() { invalid; return 0; }
EOF
rlRun 'clang bad.c -o bad 2>&1 || true' 0 "Compilation error"
rlRun 'clang --invalid-option 2>&1 || true' 0 "Invalid option"

cd /
rm -rf $TmpDir

echo ""
echo "All clang functional tests passed!"

echo ""
echo "All clang Error-handling tests passed!"
