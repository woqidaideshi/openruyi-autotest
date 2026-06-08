#!/bin/sh -eux
# 性能测试: 验证系统性能指标

echo "=== 性能测试 ==="

# 1. CPU 性能
echo "1. CPU 性能测试..."
echo "   执行 10000 次整数运算..."
time sh -c 'i=0; while [ $i -lt 10000 ]; do i=$((i+1)); done'

# 2. 内存信息
echo "2. 内存信息..."
free -h

# 3. 磁盘 I/O 性能
echo "3. 磁盘 I/O 测试..."
dd if=/dev/zero of=/tmp/perf_test_file bs=1M count=100 2>&1 | tail -1
rm -f /tmp/perf_test_file

# 4. 网络延迟测试
echo "4. 网络延迟测试..."
if command -v ping > /dev/null 2>&1; then
    ping -c 4 127.0.0.1 | tail -1
fi

# 5. 系统负载
echo "5. 系统负载..."
uptime

echo ""
echo "性能测试完成!"