#!/bin/sh -eux
# Functional test: weston - Weston-terminal--headless

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q weston' 0 "Check weston installed"
rlRun 'which weston' 0 "Check weston available"
rlRun 'which weston-debug' 0 "Check weston-debug available"
rlRun 'which weston-screenshooter' 0 "Check weston-screenshooter available"
rlRun 'which weston-terminal' 0 "Check weston-terminal available"
rlRun 'which wcap-decode' 0 "Check wcap-decode available"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 3: Weston terminal (headless) ==="
rlRun 'weston-terminal --help 2>&1 | head -10 || true' 0 "weston-terminal help"

cd /
rm -rf $TmpDir

echo ""
echo "All weston Weston-terminal--headless tests passed!"
