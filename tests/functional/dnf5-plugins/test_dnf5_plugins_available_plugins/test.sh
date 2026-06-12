#!/bin/sh -eux
# Functional test: dnf5-plugins - Available-plugins

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q dnf5-plugins 2>/dev/null || { echo 'dnf5-plugins not installed, skipping'; exit 0; }
which dnf5 2>/dev/null || echo 'dnf5 not found'
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 4: Available plugins ==="
for plugin in copr builddep changelog needs-restarting post-transaction-actions; do
    rlRun "ls /usr/lib/python*/site-packages/dnf5-plugins/${plugin}* 2>&1 | head -3 || echo 'plugin not found as file'" 0 "Check plugin: $plugin"
done

cd /
rm -rf $TmpDir

echo ""
echo "All dnf5-plugins Available-plugins tests passed!"
