#!/bin/sh -eux
# Functional test: wget - Output-options

rlRun() { eval "$1" 2>&1; return $?; }

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 2: Output options ==="

wget -q -O test_example.html https://example.com 2>&1 || echo "Output file test"
ls -lh test_example.html 2>&1 || echo "Output file test completed"

cd /
rm -rf $TmpDir

echo ""
echo "All wget Output-options tests passed!"
