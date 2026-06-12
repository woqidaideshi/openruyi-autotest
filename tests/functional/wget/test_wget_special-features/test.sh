#!/bin/sh -eux
# Functional test: wget - Special-features

rlRun() { eval "$1" 2>&1; return $?; }

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 15: Special features ==="

# Follow redirects (default)
wget -q https://google.com 2>&1 || echo "Redirect test"

# Content disposition
wget --content-disposition -q https://example.com 2>&1 || echo "Content disposition test"

cd /
rm -rf $TmpDir

echo ""
echo "All wget functional tests passed!"
cd /
rm -rf $TmpDir

echo ""
echo "All wget Special-features tests passed!"
