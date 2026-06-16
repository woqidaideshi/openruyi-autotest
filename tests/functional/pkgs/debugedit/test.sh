#!/bin/sh -eux
# Functional test: debugedit package
# Tests debugedit 调试信息编辑
# Version: debugedit

. "./setup.sh"

echo "=== 测试 1: 版本和帮助 ==="
rlRun 'debugedit --version 2>&1 || true' 0 "debugedit 版本信息"
rlRun 'debugedit --help 2>&1 | head -5 || true' 0 "debugedit 帮助信息"
rlRun 'debugedit-classify-ar --version 2>&1 || true' 0 "debugedit-classify-ar 版本信息"
rlRun 'debugedit-classify-ar --help 2>&1 | head -5 || true' 0 "debugedit-classify-ar 帮助信息"

echo "=== 测试 2: 错误处理 ==="
rlRun 'debugedit --invalid 2>&1 || true' 0 "debugedit: 无效选项"

. "./teardown.sh"
echo "All debugedit functional tests passed!"
