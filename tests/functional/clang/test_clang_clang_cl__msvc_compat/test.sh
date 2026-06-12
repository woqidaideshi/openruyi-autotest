#!/bin/sh -eux
# Functional test: clang - clang-cl--MSVC-compat

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

echo "=== Test 10: clang-cl (MSVC compat) ==="
rlRun 'clang-cl --help 2>&1 | head -5' 0 "clang-cl help"


echo ""
echo "All clang clang-cl--MSVC-compat tests passed!"
