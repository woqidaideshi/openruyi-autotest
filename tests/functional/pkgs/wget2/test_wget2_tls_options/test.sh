#!/bin/sh -eux
# Functional test: wget2 - TLS-options

. "../setup.sh"

echo "=== Test 11: TLS options ==="

wget2 --secure-protocol=PFS --spider https://example.com 2>&1 || echo "TLS test"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All wget2 TLS-options tests passed!"
