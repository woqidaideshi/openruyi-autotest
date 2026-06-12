#!/bin/sh -eux
# Functional test: psmisc - pstree-basic

rlRun() { eval "$1" 2>&1; return $?; }

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 5: pstree basic ==="

pstree | head -20

cd /
rm -rf $TmpDir

echo ""
echo "All psmisc pstree-basic tests passed!"
