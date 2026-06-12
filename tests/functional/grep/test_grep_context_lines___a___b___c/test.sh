#!/bin/sh -eux
# Functional test: grep - Context-lines---A---B---C

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q grep 2>/dev/null || { echo 'grep not installed, skipping'; exit 0; }
which grep 2>/dev/null || echo 'grep not found'
which egrep 2>/dev/null || echo 'egrep not found'
which fgrep 2>/dev/null || echo 'fgrep not found'
rlRun 'grep --version' 0 "Get grep version info"
TmpDir=$(mktemp -d)
cd $TmpDir
cat > test1.txt << 'EOF'
Hello World
hello world
HELLO WORLD
Hello Linux
Goodbye World
This is a test file
12345 numbers
Special chars: *.[]^$
EOF
cat > test2.txt << 'EOF'
apple banana cherry
Apple Banana Cherry
APPLE BANANA CHERRY
grape orange melon
EOF
mkdir subdir
echo "nested file content" > subdir/nested.txt
echo "another nested hello" > subdir/nested2.txt

echo "=== Test 10: Context lines (-A, -B, -C) ==="

# Test 10.1: After context
rlRun 'grep -A1 "Hello World" test1.txt' 0 "Context: 1 line after match"

# Test 10.2: Before context
rlRun 'grep -B1 "Hello Linux" test1.txt' 0 "Context: 1 line before match"

# Test 10.3: Both context
rlRun 'grep -C1 "Hello World" test1.txt' 0 "Context: 1 line before and after"


echo ""
echo "All grep Context-lines---A---B---C tests passed!"
