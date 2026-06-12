#!/bin/sh -eux
# Functional test: grep - Basic-pattern-matching

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

echo "=== Test 1: Basic pattern matching ==="

# Test 1.1: Simple grep
rlRun 'grep Hello test1.txt' 0 "Basic grep for Hello"
rlRun 'test $(grep Hello test1.txt | wc -l) -ge 2' 0 "Verify multiple matches"

# Test 1.2: Pipe input
rlRun 'echo "hello pipe" | grep hello' 0 "Grep from pipe"

# Test 1.3: Multiple files
rlRun 'grep Hello test1.txt test2.txt' 0 "Grep across multiple files"


echo ""
echo "All grep Basic-pattern-matching tests passed!"
