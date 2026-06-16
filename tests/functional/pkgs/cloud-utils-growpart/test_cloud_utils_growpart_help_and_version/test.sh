#!/bin/sh -eux
# Functional test: cloud-utils-growpart - Help-and-version

. "../setup.sh"

echo "=== Test 1: Help and version ==="
rlRun 'growpart --help 2>&1 | head -10' 0 "growpart help"
rlRun 'growpart -h 2>&1 | head -5' 0 "growpart -h: short help"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All cloud-utils-growpart Help-and-version tests passed!"
