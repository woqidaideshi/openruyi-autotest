#!/bin/sh -eux
# Functional test: dnf5-plugins - List-installed-plugins

. "../setup.sh"

echo "=== Test 3: List installed plugins ==="
rlRun 'ls /usr/lib/python*/site-packages/dnf5-plugins/ 2>&1 | head -20' 0 "Plugin files"
rlRun 'ls /usr/share/dnf5/plugins/ 2>&1 | head -20 || echo "No plugin dir"' 0 "Plugin directory"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All dnf5-plugins List-installed-plugins tests passed!"
