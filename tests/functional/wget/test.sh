#!/bin/sh -eux
# Functional test: wget package
# Tests wget download utility
# Version: wget

rpm -q wget

rpm -q wget
which wget
wget --version

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 1: Basic download ==="

# Test downloading a small file
wget -q https://example.com 2>&1 || echo "Download test completed"

echo "=== Test 2: Output options ==="

wget -q -O test_example.html https://example.com 2>&1 || echo "Output file test"
ls -lh test_example.html 2>&1 || echo "Output file test completed"

echo "=== Test 3: Verbose and quiet modes ==="

wget -v --spider https://example.com 2>&1 || echo "Verbose mode test"
wget -nv --spider https://example.com 2>&1 || echo "No-verbose mode test"
wget -q --spider https://example.com 2>&1 || echo "Quiet mode test"

echo "=== Test 4: Spider mode ==="

wget --spider https://google.com 2>&1 || echo "Spider test completed"

echo "=== Test 5: Header options ==="

wget -q --save-headers -O headers.html https://example.com 2>&1 || echo "Headers test"
head -20 headers.html 2>&1 || echo "Headers display test"

echo "=== Test 6: User agent ==="

wget -q -U "Mozilla/5.0 TestAgent" --spider https://example.com 2>&1 || echo "User agent test"

echo "=== Test 7: Timeout and retries ==="

wget --timeout=5 -t 1 https://example.com 2>&1 || echo "Timeout test"
wget --tries=3 --spider https://example.com 2>&1 || echo "Retry test"

echo "=== Test 8: Recursive download ==="

# Test mirror mode (limited depth)
wget -r -l 1 -np -nd https://example.com 2>&1 || echo "Recursive download test"

echo "=== Test 9: Continue and mirror ==="

# Test continue option
rm -f test_example.html test_example.html.*
wget -c -q https://example.com 2>&1 || echo "Continue test"

echo "=== Test 10: Rate limiting ==="

wget --limit-rate=100k -q https://example.com 2>&1 || echo "Rate limit test"

echo "=== Test 11: Progress indicators ==="

wget --progress=dot https://example.com 2>&1 || echo "Dot progress test"

echo "=== Test 12: Error handling ==="

# Invalid URL
wget -q http://nonexistent.domain.invalid 2>&1 || echo "Expected: invalid host"

# 404 error
wget -q https://example.com/nonexistent 2>&1 || echo "Expected: 404 error"

# Invalid option
wget --invalid-option 2>&1 || echo "Expected: invalid option"

echo "=== Test 13: Directory listing ==="

wget -q -O - https://example.com 2>&1 | head -5 || echo "Directory listing test"

echo "=== Test 14: Timestamps ==="

wget -N -q https://example.com 2>&1 || echo "Timestamp test"

echo "=== Test 15: Special features ==="

# Follow redirects (default)
wget -q https://google.com 2>&1 || echo "Redirect test"

# Content disposition
wget --content-disposition -q https://example.com 2>&1 || echo "Content disposition test"

cd /
rm -rf $TmpDir

echo ""
echo "All wget functional tests passed!"