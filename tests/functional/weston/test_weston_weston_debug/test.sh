#!/bin/sh -eux
# Functional test: weston - Weston-debug

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q weston' 0 "Check weston installed"
rlRun 'which weston' 0 "Check weston available"
rlRun 'which weston-debug' 0 "Check weston-debug available"
rlRun 'which weston-screenshooter' 0 "Check weston-screenshooter available"
rlRun 'which weston-terminal' 0 "Check weston-terminal available"
rlRun 'which wcap-decode' 0 "Check wcap-decode available"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 4: Weston debug ==="
rlRun 'weston-debug --help 2>&1 | head -5' 0 "weston-debug help"

cd /
rm -rf $TmpDir

echo ""
echo "All weston Weston-debug tests passed!"
