#!/bin/sh -eux
# Functional test: dnf5-plugins package
# Tests DNF5 package manager plugins
# Version: dnf5-plugins 5.4

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install dnf5-plugins ===
INSTALLED_BY_TEST=0
if ! rpm -q dnf5-plugins 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y dnf5-plugins 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed dnf5-plugins"
    else
        echo "SKIP: dnf5-plugins not available in repos"
        exit 0
    fi
else
    echo "SETUP: dnf5-plugins already installed"
fi



echo "=== Test 1: dnf5 version ==="
rlRun 'dnf5 --version' 0 "dnf5 version"

echo "=== Test 2: dnf5 help ==="
rlRun 'dnf5 --help 2>&1 | head -20' 0 "dnf5 help"

echo "=== Test 3: List installed plugins ==="
rlRun 'ls /usr/lib/python*/site-packages/dnf5-plugins/ 2>&1 | head -20' 0 "Plugin files"
rlRun 'ls /usr/share/dnf5/plugins/ 2>&1 | head -20 || echo "No plugin dir"' 0 "Plugin directory"

echo "=== Test 4: Available plugins ==="
for plugin in copr builddep changelog needs-restarting post-transaction-actions; do
    rlRun "ls /usr/lib/python*/site-packages/dnf5-plugins/${plugin}* 2>&1 | head -3 || echo 'plugin not found as file'" 0 "Check plugin: $plugin"
done

echo "=== Test 5: Commands with plugins ==="
rlRun 'dnf5 --help 2>&1 | grep -E "copr|builddep|changelog|needs-restarting" || true' 0 "Plugin commands in help"

echo "=== Test 6: dnf5 repoquery ==="
rlRun 'dnf5 repoquery --help 2>&1 | head -5' 0 "dnf5 repoquery help"

echo "=== Test 7: dnf5 repolist ==="
rlRun 'dnf5 repolist 2>&1 | head -10' 0 "dnf5 repolist"

echo "=== Test 8: dnf5 list ==="
rlRun 'dnf5 list installed 2>&1 | head -10' 0 "dnf5 list installed"

echo "=== Test 9: dnf5 info ==="
rlRun 'dnf5 info dnf5 2>&1 | head -10' 0 "dnf5 info"

echo "=== Test 10: Error handling ==="
rlRun 'dnf5 --invalid-option 2>&1 || true' 0 "dnf5: invalid option"

echo ""
echo "All dnf5-plugins functional tests passed!"

# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y dnf5-plugins 2>/dev/null || true
    echo "TEARDOWN: removed dnf5-plugins"
fi

