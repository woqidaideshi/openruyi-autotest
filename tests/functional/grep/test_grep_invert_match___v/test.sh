#!/bin/sh -eux
# Functional test: grep - Invert-match---v

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

echo "=== Test 3: Invert match (-v) ==="

# Test 3.1: Invert match
rlRun 'grep -v Hello test1.txt' 0 "Invert match: exclude Hello"
rlRun 'grep -v Hello test1.txt | grep -c World' 0 "Verify inverted output contains other lines"


echo ""
echo "All grep Invert-match---v tests passed!"
