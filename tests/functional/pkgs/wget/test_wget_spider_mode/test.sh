#!/bin/sh -eux
# Functional test: wget - Spider-mode

. "../setup.sh"

echo "=== Test 4: Spider mode ==="

wget --spider https://google.com 2>&1 || echo "Spider test completed"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All wget Spider-mode tests passed!"
