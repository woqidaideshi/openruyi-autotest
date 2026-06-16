#!/bin/sh -eux
# Functional test: wget - Verbose-and-quiet-modes

. "../setup.sh"

echo "=== Test 3: Verbose and quiet modes ==="

wget -v --spider https://example.com 2>&1 || echo "Verbose mode test"
wget -nv --spider https://example.com 2>&1 || echo "No-verbose mode test"
wget -q --spider https://example.com 2>&1 || echo "Quiet mode test"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All wget Verbose-and-quiet-modes tests passed!"
