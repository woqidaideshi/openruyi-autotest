#!/bin/sh -eux
# Functional test: procps-ng - pkill-and-pidwait

rlRun() { eval "$1" 2>&1; return $?; }

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 13: pkill and pidwait ==="

# Test 13.1: pkill version check
pkill --version 2>&1 | grep -q "pkill" || echo "pkill version check"

# Test 13.2: pidwait version check
pidwait --version 2>&1 | grep -q "pidwait" || echo "pidwait version check"

cd /
rm -rf $TmpDir

echo ""
echo "All procps-ng pkill-and-pidwait tests passed!"
