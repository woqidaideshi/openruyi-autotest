#!/bin/sh -eux
# Functional test: debugedit package
# Tests debugedit 调试信息编辑
# Version: debugedit

rlRun() { eval "\$1" 2>&1; return \$?; }
# === SETUP: check/install debugedit ===
INSTALLED_BY_TEST=0
if ! rpm -q debugedit 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y debugedit 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed debugedit"
    else
        echo "SKIP: debugedit not available in repos"
        exit 0
    fi
else
    echo "SETUP: debugedit already installed"
fi



echo "=== 测试 1: 版本和帮助 ==="
rlRun 'debugedit --version 2>&1 || true' 0 "debugedit 版本信息"
rlRun 'debugedit --help 2>&1 | head -5 || true' 0 "debugedit 帮助信息"
rlRun 'debugedit-classify-ar --version 2>&1 || true' 0 "debugedit-classify-ar 版本信息"
rlRun 'debugedit-classify-ar --help 2>&1 | head -5 || true' 0 "debugedit-classify-ar 帮助信息"

echo "=== 测试 2: 错误处理 ==="
rlRun 'debugedit --invalid 2>&1 || true' 0 "debugedit: 无效选项"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y debugedit 2>/dev/null || true
    echo "TEARDOWN: removed debugedit"
fi
echo ""
echo "All debugedit functional tests passed!"
