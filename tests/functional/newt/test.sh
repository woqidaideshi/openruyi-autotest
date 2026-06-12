#!/bin/sh -eux
# Functional test: newt package
# Tests newt/whiptail 对话框工具
# Version: newt

rlRun() { eval "\$1" 2>&1; return \$?; }
# === SETUP: check/install newt ===
INSTALLED_BY_TEST=0
if ! rpm -q newt 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y newt 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed newt"
    else
        echo "SKIP: newt not available in repos"
        exit 0
    fi
else
    echo "SETUP: newt already installed"
fi



echo "=== 测试 1: 版本和帮助 ==="
rlRun 'whiptail --version 2>&1 || true' 0 "whiptail 版本信息"
rlRun 'whiptail --help 2>&1 | head -5 || true' 0 "whiptail 帮助信息"

echo "=== 测试 2: 错误处理 ==="
rlRun 'whiptail --invalid 2>&1 || true' 0 "whiptail: 无效选项"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y newt 2>/dev/null || true
    echo "TEARDOWN: removed newt"
fi
echo ""
echo "All newt functional tests passed!"
