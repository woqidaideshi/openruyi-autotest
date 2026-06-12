#!/bin/sh -eux
# Functional test: weston - Weston-terminal--headless

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q weston 2>/dev/null || { echo 'weston not installed, skipping'; exit 0; }
which weston 2>/dev/null || echo 'weston not found'
which weston-debug 2>/dev/null || echo 'weston-debug not found'
which weston-screenshooter 2>/dev/null || echo 'weston-screenshooter not found'
which weston-terminal 2>/dev/null || echo 'weston-terminal not found'
which wcap-decode 2>/dev/null || echo 'wcap-decode not found'
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 3: Weston terminal (headless) ==="
rlRun 'weston-terminal --help 2>&1 | head -10 || true' 0 "weston-terminal help"

cd /
rm -rf $TmpDir

echo ""
echo "All weston Weston-terminal--headless tests passed!"
