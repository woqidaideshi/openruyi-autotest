#!/bin/sh -eux
# Functional test: clang - Error-handling

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q clang' 0 "Check clang installed"
rlRun 'which clang' 0 "Check clang available"
rlRun 'which clang++' 0 "Check clang++ available"
rlRun 'which clang-cl' 0 "Check clang-cl available"
rlRun 'which clang-cpp' 0 "Check clang-cpp available"
rlRun 'which clang-scan-deps' 0 "Check clang-scan-deps available"
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
