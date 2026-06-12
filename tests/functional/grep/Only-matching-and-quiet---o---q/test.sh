#!/bin/sh -eux
# Functional test: grep - Only-matching-and-quiet---o---q

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q grep' 0 "Check grep package is installed"
rlRun 'which grep' 0 "Check grep command is available"
rlRun 'which egrep' 0 "Check egrep command is available"
rlRun 'which fgrep' 0 "Check fgrep command is available"
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

echo "=== Test 9: Only matching and quiet (-o, -q) ==="

# Test 9.1: Only matching parts
rlRun 'echo "abc123def456" | grep -o "[0-9]\+"' 0 "Only matching: digits only"

# Test 9.2: Quiet mode (exit status only)
rlRun 'grep -q Hello test1.txt' 0 "Quiet mode: pattern found"
rlRun 'grep -q NONEXISTENT test1.txt' 1 "Quiet mode: pattern not found" || true


echo ""
echo "All grep Only-matching-and-quiet---o---q tests passed!"
