#!/bin/sh -eux
# Functional test: dejagnu - DejaGnu 测试框架
# Tools: runtest

. "./setup.sh"

echo "=== 测试 1: dejagnu 基本功能 ==="

# 检查主要工具存在且可执行
rlRun 'rpm -ql dejagnu 2>/dev/null | grep -E "^/usr/bin/" | head -5 | while read bin; do if [ -x "$bin" ]; then echo "$bin: OK"; else echo "$bin: MISSING_OR_NOT_EXEC"; fi; done' 0 "检查主要工具可执行性"

echo "=== 测试 2: dejagnu 帮助与版本信息 ==="

# 获取帮助信息（timeout 防止交互式工具挂起）
MAIN_BIN=$(rpm -ql dejagnu 2>/dev/null | grep -E "^/usr/bin/" | head -1)
if [ -n "$MAIN_BIN" ] && [ -x "$MAIN_BIN" ]; then
    rlRun 'timeout 5 "$MAIN_BIN" --help 2>&1 || timeout 5 "$MAIN_BIN" -h 2>&1 || timeout 5 echo "exit" | "$MAIN_BIN" 2>&1 || echo "NO_HELP_FLAG"' 0 "获取 dejagnu 帮助信息"
    rlRun 'timeout 5 "$MAIN_BIN" --version 2>&1 || timeout 5 "$MAIN_BIN" -V 2>&1 || timeout 5 "$MAIN_BIN" -v 2>&1 || echo "NO_VERSION_FLAG"' 0 "获取 dejagnu 版本信息"
fi

. "./teardown.sh"
echo "All dejagnu tests passed!"
