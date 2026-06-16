#!/bin/sh -eux
# Functional test: grep - Word-and-line-matching---w---x

. "../setup.sh"

echo "=== Test 4: Word and line matching (-w, -x) ==="

# Test 4.1: Whole word match
rlRun 'echo "helloworld" > word_test.txt' 0 "Create word test file"
rlRun 'echo "hello world" >> word_test.txt' 0 "Add line with separate words"
rlRun 'test $(grep -w hello word_test.txt | wc -l) -eq 1' 0 "Whole word match: hello matches only standalone"

# Test 4.2: Whole line match
rlRun 'echo "exact match" > line_test.txt' 0 "Create line test file"
rlRun 'echo "not exact match here" >> line_test.txt' 0 "Add different line"
rlRun 'test $(grep -x "exact match" line_test.txt | wc -l) -eq 1' 0 "Whole line exact match"

. "../teardown.sh"
echo "All grep Word-and-line-matching---w---x tests passed!"
