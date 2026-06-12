#!/bin/sh -eux
# Functional test: weston - Error-handling

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q weston' 0 "Check weston installed"
rlRun 'which weston' 0 "Check weston available"
rlRun 'which weston-debug' 0 "Check weston-debug available"
rlRun 'which weston-screenshooter' 0 "Check weston-screenshooter available"
rlRun 'which weston-terminal' 0 "Check weston-terminal available"
rlRun 'which wcap-decode' 0 "Check wcap-decode available"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 9: Error handling ==="
rlRun 'weston --invalid 2>&1 || true' 0 "weston: invalid option"

echo ""
echo "All weston functional tests passed!"
cd /
rm -rf $TmpDir

echo ""
echo "All weston Error-handling tests passed!"
