#!/bin/sh -eux
# 兼容性测试: 验证系统兼容性

echo "=== 兼容性测试 ==="

# 1. 检查操作系统版本
echo "1. 检查操作系统版本..."
if [ -f /etc/os-release ]; then
    cat /etc/os-release
elif [ -f /etc/redhat-release ]; then
    cat /etc/redhat-release
fi

# 2. 检查内核版本
echo "2. 检查内核版本..."
uname -a

# 3. 检查 CPU 架构
echo "3. 检查 CPU 架构..."
uname -m
lscpu | grep -E 'Architecture|Model name|CPU\(s\)' || true

# 4. 检查关键依赖
echo "4. 检查关键依赖..."
for cmd in python3 curl wget git; do
    if command -v $cmd > /dev/null 2>&1; then
        echo "   $cmd: $(command -v $cmd)"
    else
        echo "   $cmd: 未安装"
    fi
done

# 5. 检查文件系统
echo "5. 检查文件系统..."
df -hT | head -10

echo ""
echo "兼容性测试完成!"