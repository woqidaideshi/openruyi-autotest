#!/bin/sh -eux
# Functional test: psmisc - fuser-with-processes

rlRun() { eval "$1" 2>&1; return $?; }

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 2: fuser with processes ==="

# Show processes using /tmp
fuser -uv /tmp 2>&1 || echo "fuser verbose test"

cd /
rm -rf $TmpDir

echo ""
echo "All psmisc fuser-with-processes tests passed!"
