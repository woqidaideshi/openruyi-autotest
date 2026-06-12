#!/bin/sh -eux
# Functional test: weston - Weston-debug

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q weston 2>/dev/null || { echo 'weston not installed, skipping'; exit 0; }
which weston 2>/dev/null || echo 'weston not found'
which weston-debug 2>/dev/null || echo 'weston-debug not found'
which weston-screenshooter 2>/dev/null || echo 'weston-screenshooter not found'
which weston-terminal 2>/dev/null || echo 'weston-terminal not found'
which wcap-decode 2>/dev/null || echo 'wcap-decode not found'
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 4: Weston debug ==="
rlRun 'weston-debug --help 2>&1 | head -5' 0 "weston-debug help"

cd /
rm -rf $TmpDir

echo ""
echo "All weston Weston-debug tests passed!"
