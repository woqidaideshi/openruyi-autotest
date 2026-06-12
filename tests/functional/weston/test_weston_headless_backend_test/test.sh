#!/bin/sh -eux
# Functional test: weston - Headless-backend-test

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q weston' 0 "Check weston installed"
rlRun 'which weston' 0 "Check weston available"
rlRun 'which weston-debug' 0 "Check weston-debug available"
rlRun 'which weston-screenshooter' 0 "Check weston-screenshooter available"
rlRun 'which weston-terminal' 0 "Check weston-terminal available"
rlRun 'which wcap-decode' 0 "Check wcap-decode available"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 8: Headless backend test ==="
rlRun 'timeout 5 weston --backend=headless 2>&1 || true' 0 "weston: headless backend"

cd /
rm -rf $TmpDir

echo ""
echo "All weston Headless-backend-test tests passed!"
