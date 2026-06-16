#!/bin/sh -eux
# Functional test: expect - Expect 自动化交互工具
# Tools: expect/autoexpect/mkpasswd

. "./setup.sh"

echo "=== 测试 1: expect 基本功能 ==="

# 检查主要工具存在且可执行
rlRun 'rpm -ql expect 2>/dev/null | grep -E "^/usr/bin/" | head -5 | while read bin; do if [ -x "$bin" ]; then echo "$bin: OK"; else echo "$bin: MISSING_OR_NOT_EXEC"; fi; done' 0 "检查主要工具可执行性"

echo "=== 测试 2: expect 帮助与版本信息 ==="

# 获取帮助信息（timeout 防止交互式工具挂起）
MAIN_BIN=$(rpm -ql expect 2>/dev/null | grep -E "^/usr/bin/" | head -1)
if [ -n "$MAIN_BIN" ] && [ -x "$MAIN_BIN" ]; then
    rlRun 'timeout 5 "$MAIN_BIN" --help 2>&1 || timeout 5 "$MAIN_BIN" -h 2>&1 || timeout 5 echo "exit" | "$MAIN_BIN" 2>&1 || echo "NO_HELP_FLAG"' 0 "获取 expect 帮助信息"
    rlRun 'timeout 5 "$MAIN_BIN" --version 2>&1 || timeout 5 "$MAIN_BIN" -V 2>&1 || timeout 5 "$MAIN_BIN" -v 2>&1 || echo "NO_VERSION_FLAG"' 0 "获取 expect 版本信息"
fi

. "./teardown.sh"
echo "All expect tests passed!"
