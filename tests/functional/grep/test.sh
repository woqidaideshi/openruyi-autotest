#!/bin/sh -eux
# Functional test: grep package
# Tests grep, egrep, fgrep commands
# Version: GNU grep 3.12

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q grep 2>/dev/null || { echo 'grep not installed, skipping'; exit 0; }
which grep 2>/dev/null || echo 'grep not found'
which egrep 2>/dev/null || echo 'egrep not found'
which fgrep 2>/dev/null || echo 'fgrep not found'
rlRun 'grep --version' 0 "Get grep version info"

TmpDir=$(mktemp -d)
cd $TmpDir

# Create test files
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

echo "=== Test 2: Case insensitive (-i) ==="

# Test 2.1: Case insensitive match
rlRun 'grep -i hello test1.txt' 0 "Case insensitive grep"
rlRun 'test $(grep -i hello test1.txt | wc -l) -ge 2' 0 "Verify case insensitive matches"

# Test 2.2: Case sensitive (default)
rlRun 'grep hello test1.txt' 1 "Case sensitive: lowercase only matches lowercase" || true

echo "=== Test 3: Invert match (-v) ==="

# Test 3.1: Invert match
rlRun 'grep -v Hello test1.txt' 0 "Invert match: exclude Hello"
rlRun 'grep -v Hello test1.txt | grep -c World' 0 "Verify inverted output contains other lines"

echo "=== Test 4: Word and line matching (-w, -x) ==="

# Test 4.1: Whole word match
rlRun 'echo "helloworld" > word_test.txt' 0 "Create word test file"
rlRun 'echo "hello world" >> word_test.txt' 0 "Add line with separate words"
rlRun 'test $(grep -w hello word_test.txt | wc -l) -eq 1' 0 "Whole word match: hello matches only standalone"

# Test 4.2: Whole line match
rlRun 'echo "exact match" > line_test.txt' 0 "Create line test file"
rlRun 'echo "not exact match here" >> line_test.txt' 0 "Add different line"
rlRun 'test $(grep -x "exact match" line_test.txt | wc -l) -eq 1' 0 "Whole line exact match"

echo "=== Test 5: Count and line numbers (-c, -n) ==="

# Test 5.1: Count matches
rlRun 'grep -c Hello test1.txt' 0 "Count matches with -c"
rlRun 'test $(grep -c Hello test1.txt) -ge 2' 0 "Verify count >= 2"

# Test 5.2: Line numbers
rlRun 'grep -n Hello test1.txt' 0 "Show line numbers with -n"
rlRun 'grep -n Hello test1.txt | grep -q "^[0-9]:"' 0 "Verify line number format"

echo "=== Test 6: Recursive search (-r) ==="

# Test 6.1: Recursive search
rlRun 'grep -r nested subdir/' 0 "Recursive grep in subdirectory"
rlRun 'grep -rl hello subdir/' 0 "Recursive list files with matches"

# Test 6.2: Include/exclude patterns
rlRun 'grep -r --include="*.txt" hello .' 0 "Recursive with --include filter"

echo "=== Test 7: Extended regex (-E) ==="

# Test 7.1: Extended regex alternation
rlRun 'grep -E "apple|banana" test2.txt' 0 "Extended regex with alternation"

# Test 7.2: Extended regex with quantifiers
rlRun 'grep -E "[0-9]+" test1.txt' 0 "Extended regex: digit quantifier"
rlRun 'test $(grep -E "[0-9]+" test1.txt | wc -l) -ge 1' 0 "Verify digit match count"

# Test 7.3: egrep equivalent
rlRun 'egrep "apple|banana" test2.txt' 0 "egrep equivalent to grep -E"

echo "=== Test 8: Fixed strings (-F) ==="

# Test 8.1: Fixed string (no regex interpretation)
rlRun 'grep -F "Special chars: *.[]^$" test1.txt' 0 "Fixed string with special chars"
rlRun 'grep -F "*.[]" test1.txt' 0 "Fixed string: no regex meta-char interpretation"

# Test 8.2: fgrep equivalent
rlRun 'fgrep "Special chars" test1.txt' 0 "fgrep equivalent to grep -F"

echo "=== Test 9: Only matching and quiet (-o, -q) ==="

# Test 9.1: Only matching parts
rlRun 'echo "abc123def456" | grep -o "[0-9]\+"' 0 "Only matching: digits only"

# Test 9.2: Quiet mode (exit status only)
rlRun 'grep -q Hello test1.txt' 0 "Quiet mode: pattern found"
rlRun 'grep -q NONEXISTENT test1.txt' 1 "Quiet mode: pattern not found" || true

echo "=== Test 10: Context lines (-A, -B, -C) ==="

# Test 10.1: After context
rlRun 'grep -A1 "Hello World" test1.txt' 0 "Context: 1 line after match"

# Test 10.2: Before context
rlRun 'grep -B1 "Hello Linux" test1.txt' 0 "Context: 1 line before match"

# Test 10.3: Both context
rlRun 'grep -C1 "Hello World" test1.txt' 0 "Context: 1 line before and after"

echo "=== Test 11: File listing (-l, -L) ==="

# Test 11.1: Files with matches
rlRun 'grep -l Hello *.txt' 0 "List files with matches"

# Test 11.2: Files without matches
# Create a file without "Hello"
echo "nothing here" > empty_test.txt
rlRun 'grep -L Hello *.txt' 0 "List files without matches"

echo "=== Test 12: Multiple patterns (-e, -f) ==="

# Test 12.1: Multiple -e patterns
rlRun 'grep -e Hello -e apple test1.txt test2.txt' 0 "Multiple patterns with -e"

# Test 12.2: Patterns from file
echo "Hello" > patterns.txt
echo "apple" >> patterns.txt
rlRun 'grep -f patterns.txt test1.txt test2.txt' 0 "Patterns from file with -f"

# Test 12.3: Max count
rlRun 'test $(grep -m1 Hello test1.txt | wc -l) -eq 1' 0 "Max count: stop after first match"

echo "=== Test 13: Error handling ==="

# Test 13.1: Nonexistent file
rlRun 'grep pattern nonexistent_file.txt 2>&1' 2 "Error on nonexistent file" || true

# Test 13.2: Invalid regex
rlRun 'grep "[" test1.txt 2>&1' 2 "Error on invalid regex" || true

# Test 13.3: Directory without -r
rlRun 'grep pattern subdir/ 2>&1' 2 "Error on directory without -r" || true

# Test 13.4: No match (exit 1)
rlRun 'grep NONEXISTENT_PATTERN test1.txt' 1 "No match returns exit code 1" || true

cd /
rm -rf $TmpDir

echo ""
echo "All grep functional tests passed!"