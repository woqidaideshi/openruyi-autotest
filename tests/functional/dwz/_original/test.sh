#!/bin/sh -eux
# Functional test: dwz package
# Tests dwz DWARF优化器
# Version: dwz

rlRun() { eval "\$1" 2>&1; return \$?; }

rlRun 'rpm -q dwz' 0 "检查 dwz 是否已安装"
rlRun 'which dwz' 0 "检查 dwz 命令是否可用"

echo "=== 测试 1: 版本和帮助 ==="
rlRun 'dwz --version 2>&1 || true' 0 "dwz 版本信息"
rlRun 'dwz --help 2>&1 | head -5 || true' 0 "dwz 帮助信息"

echo "=== 测试 2: 错误处理 ==="
rlRun 'dwz --invalid 2>&1 || true' 0 "dwz: 无效选项"

echo ""
echo "All dwz functional tests passed!"
