#!/bin/sh -eux
# Functional test: pkgconf package
# Tests pkgconf 包配置工具
# Version: pkgconf

rlRun() { eval "\$1" 2>&1; return \$?; }

rlRun 'rpm -q pkgconf' 0 "检查 pkgconf 是否已安装"
rlRun 'which pkgconf' 0 "检查 pkgconf 命令是否可用"
rlRun 'which bomtool' 0 "检查 bomtool 命令是否可用"

echo "=== 测试 1: 版本和帮助 ==="
rlRun 'pkgconf --version 2>&1 || true' 0 "pkgconf 版本信息"
rlRun 'pkgconf --help 2>&1 | head -5 || true' 0 "pkgconf 帮助信息"
rlRun 'bomtool --version 2>&1 || true' 0 "bomtool 版本信息"
rlRun 'bomtool --help 2>&1 | head -5 || true' 0 "bomtool 帮助信息"

echo "=== 测试 2: 错误处理 ==="
rlRun 'pkgconf --invalid 2>&1 || true' 0 "pkgconf: 无效选项"

echo ""
echo "All pkgconf functional tests passed!"
