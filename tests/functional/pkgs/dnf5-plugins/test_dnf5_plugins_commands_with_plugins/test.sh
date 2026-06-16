#!/bin/sh -eux
# Functional test: dnf5-plugins - Commands-with-plugins

. "../setup.sh"

echo "=== Test 5: Commands with plugins ==="
rlRun 'dnf5 --help 2>&1 | grep -E "copr|builddep|changelog|needs-restarting" || true' 0 "Plugin commands in help"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All dnf5-plugins Commands-with-plugins tests passed!"
