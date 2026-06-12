#!/bin/sh -eux
# Functional test: grep - Multiple-patterns---e---f

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

echo "=== Test 12: Multiple patterns (-e, -f) ==="

# Test 12.1: Multiple -e patterns
rlRun 'grep -e Hello -e apple test1.txt test2.txt' 0 "Multiple patterns with -e"

# Test 12.2: Patterns from file
echo "Hello" > patterns.txt
echo "apple" >> patterns.txt
rlRun 'grep -f patterns.txt test1.txt test2.txt' 0 "Patterns from file with -f"

# Test 12.3: Max count
rlRun 'test $(grep -m1 Hello test1.txt | wc -l) -eq 1' 0 "Max count: stop after first match"


echo ""
echo "All grep Multiple-patterns---e---f tests passed!"
