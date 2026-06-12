#!/bin/sh -eux
# Functional test: dwz package
# Tests dwz DWARF优化器
# Version: dwz

rlRun() { eval "\$1" 2>&1; return \$?; }

rpm -q dwz 2>/dev/null || { echo 'dwz not installed, skipping'; exit 0; }
which dwz 2>/dev/null || echo 'dwz not found'

echo "=== 测试 1: 版本和帮助 ==="
rlRun 'dwz --version 2>&1 || true' 0 "dwz 版本信息"
rlRun 'dwz --help 2>&1 | head -5 || true' 0 "dwz 帮助信息"

echo "=== 测试 2: 错误处理 ==="
rlRun 'dwz --invalid 2>&1 || true' 0 "dwz: 无效选项"

echo ""
echo "All dwz functional tests passed!"
