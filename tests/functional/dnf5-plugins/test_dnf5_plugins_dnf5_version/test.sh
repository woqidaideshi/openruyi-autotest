#!/bin/sh -eux
# Functional test: dnf5-plugins - dnf5-version

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q dnf5-plugins' 0 "Check dnf5-plugins installed"
rlRun 'which dnf5' 0 "Check dnf5 available"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 1: dnf5 version ==="
rlRun 'dnf5 --version' 0 "dnf5 version"

cd /
rm -rf $TmpDir

echo ""
echo "All dnf5-plugins dnf5-version tests passed!"
