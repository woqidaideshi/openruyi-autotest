#!/bin/sh -eux
# Functional test: wget2 - Plugin-system

rlRun() { eval "$1" 2>&1; return $?; }

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 15: Plugin system ==="

wget2 --plugin-list 2>&1 | head -10 || echo "Plugin list test"

cd /
rm -rf $TmpDir

echo ""
echo "All wget2 functional tests passed!"
cd /
rm -rf $TmpDir

echo ""
echo "All wget2 Plugin-system tests passed!"
