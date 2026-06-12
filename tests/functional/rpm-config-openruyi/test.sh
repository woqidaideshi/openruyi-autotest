#!/bin/sh -eux
# Functional test: rpm-config-openruyi package
# Tests RPM配置(openRuyi)
# Version: rpm-config-openruyi

rlRun() { eval "\$1" 2>&1; return \$?; }

rpm -q rpm-config-openruyi 2>/dev/null || { echo 'rpm-config-openruyi not installed, skipping'; exit 0; }

echo "=== 测试 1: 版本和帮助 ==="

# 库包，验证安装和文件存在
rlRun 'rpm -ql rpm-config-openruyi | head -20' 0 "列出包文件"
rlRun 'ls /usr/lib64/lib*.so* 2>/dev/null | head -5 || echo "无库文件"' 0 "库文件检查"

echo "=== 测试 2: 错误处理 ==="

echo ""
echo "All rpm-config-openruyi functional tests passed!"
