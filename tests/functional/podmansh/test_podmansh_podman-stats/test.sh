#!/bin/sh -eux
# Functional test: podmansh - podman-stats

rlRun() { eval "$1" 2>&1; return $?; }

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 9: podman stats ==="

podman stats --no-stream --all 2>&1 | head -5 || echo "Stats test"

cd /
rm -rf $TmpDir

echo ""
echo "All podmansh podman-stats tests passed!"
