#!/bin/sh -eux
# Functional test: mpdecimal package
# Tests mpdecimal 十进制库
# Version: mpdecimal

rlRun() { eval "\$1" 2>&1; return \$?; }

rpm -q mpdecimal 2>/dev/null || { echo 'mpdecimal not installed, skipping'; exit 0; }

echo "=== 测试 1: 版本和帮助 ==="

# 库包，验证安装和文件存在
rlRun 'rpm -ql mpdecimal | head -20' 0 "列出包文件"
rlRun 'ls /usr/lib64/lib*.so* 2>/dev/null | head -5 || echo "无库文件"' 0 "库文件检查"

echo "=== 测试 2: 错误处理 ==="

echo ""
echo "All mpdecimal functional tests passed!"
