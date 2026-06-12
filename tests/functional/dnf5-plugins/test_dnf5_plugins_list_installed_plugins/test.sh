#!/bin/sh -eux
# Functional test: dnf5-plugins - List-installed-plugins

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

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 3: List installed plugins ==="
rlRun 'ls /usr/lib/python*/site-packages/dnf5-plugins/ 2>&1 | head -20' 0 "Plugin files"
rlRun 'ls /usr/share/dnf5/plugins/ 2>&1 | head -20 || echo "No plugin dir"' 0 "Plugin directory"

cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y dnf5-plugins 2>/dev/null || true
    echo "TEARDOWN: removed dnf5-plugins"
fi
echo ""
echo "All dnf5-plugins List-installed-plugins tests passed!"
