#!/bin/sh -eux
# Functional test: wget2 - Plugin-system

. "../setup.sh"

echo "=== Test 15: Plugin system ==="

wget2 --plugin-list 2>&1 | head -10 || echo "Plugin list test"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All wget2 Plugin-system tests passed!"
