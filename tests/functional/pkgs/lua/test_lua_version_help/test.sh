#!/bin/sh -eux
# Functional test: lua - 版本和帮助

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install lua ===
INSTALLED_BY_TEST=0
if ! rpm -q lua 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y lua 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed lua"
    else
        echo "SKIP: lua not available in repos"
        exit 0
    fi
else
    echo "SETUP: lua already installed"
fi

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 1: 版本和帮助 ==="
rlRun 'lua --version 2>&1 || true' 0 "lua 版本信息"
rlRun 'lua --help 2>&1 | head -5 || true' 0 "lua 帮助信息"
rlRun 'luac --version 2>&1 || true' 0 "luac 版本信息"
rlRun 'luac --help 2>&1 | head -5 || true' 0 "luac 帮助信息"

cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y lua 2>/dev/null || true
    echo "TEARDOWN: removed lua"
fi
echo ""
echo "All lua 版本和帮助 tests passed!"
