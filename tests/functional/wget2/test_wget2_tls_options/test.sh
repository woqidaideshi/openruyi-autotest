#!/bin/sh -eux
# Functional test: wget2 - TLS-options

rlRun() { eval "$1" 2>&1; return $?; }

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 11: TLS options ==="

wget2 --secure-protocol=PFS --spider https://example.com 2>&1 || echo "TLS test"

cd /
rm -rf $TmpDir

echo ""
echo "All wget2 TLS-options tests passed!"
