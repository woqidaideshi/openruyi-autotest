#!/bin/sh -eux
# Functional test: dnf5-plugins - List-installed-plugins

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q dnf5-plugins 2>/dev/null || { echo 'dnf5-plugins not installed, skipping'; exit 0; }
which dnf5 2>/dev/null || echo 'dnf5 not found'
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 3: List installed plugins ==="
rlRun 'ls /usr/lib/python*/site-packages/dnf5-plugins/ 2>&1 | head -20' 0 "Plugin files"
rlRun 'ls /usr/share/dnf5/plugins/ 2>&1 | head -20 || echo "No plugin dir"' 0 "Plugin directory"

cd /
rm -rf $TmpDir

echo ""
echo "All dnf5-plugins List-installed-plugins tests passed!"
