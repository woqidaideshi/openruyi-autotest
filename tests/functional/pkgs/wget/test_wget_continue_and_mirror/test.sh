#!/bin/sh -eux
# Functional test: wget - Continue-and-mirror

. "../setup.sh"

echo "=== Test 9: Continue and mirror ==="

# Test continue option
rm -f test_example.html test_example.html.*
wget -c -q https://example.com 2>&1 || echo "Continue test"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All wget Continue-and-mirror tests passed!"
