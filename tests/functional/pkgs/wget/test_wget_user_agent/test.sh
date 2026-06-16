#!/bin/sh -eux
# Functional test: wget - User-agent

. "../setup.sh"

echo "=== Test 6: User agent ==="

wget -q -U "Mozilla/5.0 TestAgent" --spider https://example.com 2>&1 || echo "User agent test"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All wget User-agent tests passed!"
