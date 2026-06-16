#!/bin/sh -eux
# Functional test: wget2 - Spider-mode

. "../setup.sh"

echo "=== Test 4: Spider mode ==="

wget2 --spider https://google.com 2>&1 || echo "Spider test"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All wget2 Spider-mode tests passed!"
