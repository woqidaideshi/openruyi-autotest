#!/bin/sh -eux
# Functional test: grep - Invert-match---v

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

echo "=== Test 3: Invert match (-v) ==="

# Test 3.1: Invert match
rlRun 'grep -v Hello test1.txt' 0 "Invert match: exclude Hello"
rlRun 'grep -v Hello test1.txt | grep -c World' 0 "Verify inverted output contains other lines"


echo ""
echo "All grep Invert-match---v tests passed!"
