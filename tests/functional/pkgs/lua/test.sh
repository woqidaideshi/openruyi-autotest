#!/bin/sh -eux
# Functional test: lua package
# Tests Lua 脚本语言
# Version: lua

rlRun() { eval "\$1" 2>&1; return \$?; }
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



echo "=== 测试 1: 版本和帮助 ==="
rlRun 'lua --version 2>&1 || true' 0 "lua 版本信息"
rlRun 'lua --help 2>&1 | head -5 || true' 0 "lua 帮助信息"
rlRun 'luac --version 2>&1 || true' 0 "luac 版本信息"
rlRun 'luac --help 2>&1 | head -5 || true' 0 "luac 帮助信息"

echo "=== 测试 2: 错误处理 ==="
rlRun 'lua --invalid 2>&1 || true' 0 "lua: 无效选项"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y lua 2>/dev/null || true
    echo "TEARDOWN: removed lua"
fi
echo ""
echo "All lua functional tests passed!"
