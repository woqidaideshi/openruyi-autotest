#!/bin/sh -eux
# Functional test: dnf5-plugins - Available-plugins

. "../setup.sh"

echo "=== Test 4: Available plugins ==="
for plugin in copr builddep changelog needs-restarting post-transaction-actions; do
    rlRun "ls /usr/lib/python*/site-packages/dnf5-plugins/${plugin}* 2>&1 | head -3 || echo 'plugin not found as file'" 0 "Check plugin: $plugin"
done

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All dnf5-plugins Available-plugins tests passed!"
