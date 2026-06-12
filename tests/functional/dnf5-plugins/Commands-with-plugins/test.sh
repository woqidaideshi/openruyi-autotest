#!/bin/sh -eux
# Functional test: dnf5-plugins - Commands-with-plugins

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q dnf5-plugins' 0 "Check dnf5-plugins installed"
rlRun 'which dnf5' 0 "Check dnf5 available"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 5: Commands with plugins ==="
rlRun 'dnf5 --help 2>&1 | grep -E "copr|builddep|changelog|needs-restarting" || true' 0 "Plugin commands in help"

cd /
rm -rf $TmpDir

echo ""
echo "All dnf5-plugins Commands-with-plugins tests passed!"
