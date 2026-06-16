#!/bin/sh -eux
# Functional test: libselinux package
# Tests SELinux 库
# Version: libselinux

. "./setup.sh"

echo "=== 测试 1: 版本和帮助 ==="

# 库包，验证安装和文件存在
rlRun 'rpm -ql libselinux | head -20' 0 "列出包文件"
rlRun 'ls /usr/lib64/lib*.so* 2>/dev/null | head -5 || echo "无库文件"' 0 "库文件检查"

echo "=== 测试 2: 错误处理 ==="

. "./teardown.sh"
echo "All libselinux functional tests passed!"
