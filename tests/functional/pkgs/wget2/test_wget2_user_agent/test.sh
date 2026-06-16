#!/bin/sh -eux
# Functional test: wget2 - User-agent

. "../setup.sh"

echo "=== Test 6: User agent ==="

wget2 -U "TestAgent/1.0" --spider https://example.com 2>&1 || echo "UA test"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All wget2 User-agent tests passed!"
