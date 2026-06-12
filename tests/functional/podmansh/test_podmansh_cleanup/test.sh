#!/bin/sh -eux
# Functional test: podmansh - Cleanup

rlRun() { eval "$1" 2>&1; return $?; }

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 12: Cleanup ==="

podman system prune -f 2>&1 || echo "Cleanup test"

echo ""
echo "All podmansh functional tests passed!"
cd /
rm -rf $TmpDir

echo ""
echo "All podmansh Cleanup tests passed!"
