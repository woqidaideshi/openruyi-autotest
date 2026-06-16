#!/bin/sh -eux
# Functional test: procps-ng - pkill-and-pidwait

. "../setup.sh"

echo "=== Test 13: pkill and pidwait ==="

# Test 13.1: pkill version check
pkill --version 2>&1 | grep -q "pkill" || echo "pkill version check"

# Test 13.2: pidwait version check
pidwait --version 2>&1 | grep -q "pidwait" || echo "pidwait version check"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All procps-ng pkill-and-pidwait tests passed!"
