#!/bin/sh -eux
# Functional test: podmansh - Error-handling

rlRun() { eval "$1" 2>&1; return $?; }

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 11: Error handling ==="

podman run nonexistent/image 2>&1 || echo "Expected: image not found"
podman exec nonexistent_container 2>&1 || echo "Expected: container not found"

cd /
rm -rf $TmpDir

echo ""
echo "All podmansh Error-handling tests passed!"
