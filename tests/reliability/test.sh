#!/bin/sh -eux
# 可靠性测试: 验证系统稳定性和可靠性

echo "=== 可靠性测试 ==="

# 1. 检查系统运行时间
echo "1. 系统运行时间..."
uptime

# 2. 检查关键服务状态
echo "2. 检查关键服务状态..."
for svc in sshd crond rsyslog; do
    if command -v systemctl > /dev/null 2>&1; then
        status=$(systemctl is-active $svc 2>/dev/null || echo "unknown")
        echo "   $svc: $status"
    else
        echo "   $svc: systemctl 不可用"
    fi
done

# 3. 检查磁盘使用率
echo "3. 检查磁盘使用率..."
df -h | grep -vE '^Filesystem|tmpfs|devtmpfs'

# 4. 检查系统日志错误
echo "4. 检查系统日志错误..."
if [ -f /var/log/messages ]; then
    grep -i "error\|fail\|critical" /var/log/messages 2>/dev/null | tail -5 || echo "   无错误日志"
elif [ -f /var/log/syslog ]; then
    grep -i "error\|fail\|critical" /var/log/syslog 2>/dev/null | tail -5 || echo "   无错误日志"
else
    echo "   未找到系统日志文件"
fi

# 5. 内存压力测试（简单）
echo "5. 内存使用检查..."
free -h
cat /proc/meminfo 2>/dev/null | grep -E 'MemTotal|MemAvailable|MemFree' || true

echo ""
echo "可靠性测试完成!"