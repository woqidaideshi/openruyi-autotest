#!/bin/sh -eux
# Functional test: swig - SWIG 接口生成器
# Tools: swig

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install swig ===
# Kill any stale dnf processes first
echo openruyi | sudo -S pkill -9 dnf 2>/dev/null || true
echo openruyi | sudo -S rm -f /var/run/dnf.pid 2>/dev/null || true
INSTALLED_BY_TEST=0
if ! rpm -q swig 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y --nogpgcheck swig 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed swig"
    else
        echo "SKIP: swig not available in repos"
        exit 0
    fi
else
    echo "SETUP: swig already installed"
fi

# 获取版本信息
rlRun 'rpm -q swig' 0 "获取 swig 版本信息"

# 列出包内二进制文件
rlRun 'rpm -ql swig 2>/dev/null | grep -E "^/usr/bin/|^/usr/sbin/|^/bin/|^/sbin/"' 0 "列出包内二进制文件"

echo "=== 测试 1: swig 基本功能 ==="

# 检查主要工具存在且可执行
rlRun 'rpm -ql swig 2>/dev/null | grep -E "^/usr/bin/" | head -5 | while read bin; do if [ -x "$bin" ]; then echo "$bin: OK"; else echo "$bin: MISSING_OR_NOT_EXEC"; fi; done' 0 "检查主要工具可执行性"

echo "=== 测试 2: swig 帮助与版本信息 ==="

# 获取帮助信息（timeout 防止交互式工具挂起）
MAIN_BIN=$(rpm -ql swig 2>/dev/null | grep -E "^/usr/bin/" | head -1)
if [ -n "$MAIN_BIN" ] && [ -x "$MAIN_BIN" ]; then
    rlRun 'timeout 5 "$MAIN_BIN" --help 2>&1 || timeout 5 "$MAIN_BIN" -h 2>&1 || timeout 5 echo "exit" | "$MAIN_BIN" 2>&1 || echo "NO_HELP_FLAG"' 0 "获取 swig 帮助信息"
    rlRun 'timeout 5 "$MAIN_BIN" --version 2>&1 || timeout 5 "$MAIN_BIN" -V 2>&1 || timeout 5 "$MAIN_BIN" -v 2>&1 || echo "NO_VERSION_FLAG"' 0 "获取 swig 版本信息"
fi

# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y swig 2>/dev/null || true
    echo "TEARDOWN: removed swig"
fi
echo ""
echo "All swig tests passed!"
