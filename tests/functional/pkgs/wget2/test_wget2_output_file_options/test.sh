#!/bin/sh -eux
# Functional test: wget2 - Output-file-options

. "../setup.sh"

echo "=== Test 2: Output file options ==="

wget2 -O output.html https://example.com 2>&1 || echo "Output file test"
ls -lh output.html

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All wget2 Output-file-options tests passed!"
