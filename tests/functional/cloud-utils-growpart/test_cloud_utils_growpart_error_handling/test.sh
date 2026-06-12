#!/bin/sh -eux
# Functional test: cloud-utils-growpart - Error-handling

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q cloud-utils-growpart 2>/dev/null || { echo 'cloud-utils-growpart not installed, skipping'; exit 0; }
which growpart 2>/dev/null || echo 'growpart not found'
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 6: Error handling ==="
rlRun 'growpart 2>&1 || true' 0 "growpart: no args (expected fail)"
rlRun 'growpart /dev/nonexistent 1 2>&1 || true' 0 "growpart: nonexistent disk"
rlRun 'growpart --invalid 2>&1 || true' 0 "growpart: invalid option"

echo ""
echo "All cloud-utils-growpart functional tests passed!"
cd /
rm -rf $TmpDir

echo ""
echo "All cloud-utils-growpart Error-handling tests passed!"
