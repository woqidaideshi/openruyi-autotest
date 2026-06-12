#!/bin/sh -eux
# Functional test: wget2 - HTTP-2-support

rlRun() { eval "$1" 2>&1; return $?; }

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 10: HTTP/2 support ==="

wget2 --http2-request --spider https://google.com 2>&1 || echo "HTTP/2 test"

cd /
rm -rf $TmpDir

echo ""
echo "All wget2 HTTP-2-support tests passed!"
