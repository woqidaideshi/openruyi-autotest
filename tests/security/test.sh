#!/bin/sh -eux
# 安全测试: 验证系统安全特性

echo "=== 安全测试 ==="

# 1. 检查 SSH 配置
echo "1. 检查 SSH 配置..."
if [ -f /etc/ssh/sshd_config ]; then
    echo "   SSH 配置文件存在"
    grep -E '^PermitRootLogin|^PasswordAuthentication|^PubkeyAuthentication' /etc/ssh/sshd_config || true
else
    echo "   SSH 配置文件不存在 (跳过)"
fi

# 2. 检查防火墙状态
echo "2. 检查防火墙状态..."
if command -v firewall-cmd > /dev/null 2>&1; then
    firewall-cmd --state || true
elif command -v ufw > /dev/null 2>&1; then
    ufw status || true
elif command -v iptables > /dev/null 2>&1; then
    iptables -L -n | head -10 || true
else
    echo "   未检测到防火墙工具"
fi

# 3. 检查 SELinux 状态
echo "3. 检查 SELinux/AppArmor 状态..."
if command -v getenforce > /dev/null 2>&1; then
    getenforce || true
elif command -v aa-status > /dev/null 2>&1; then
    aa-status --enabled && echo "AppArmor enabled" || echo "AppArmor disabled"
else
    echo "   未检测到 SELinux/AppArmor"
fi

# 4. 检查关键文件权限
echo "4. 检查关键文件权限..."
for f in /etc/passwd /etc/shadow /etc/group; do
    if [ -f "$f" ]; then
        ls -la "$f"
    fi
done

echo ""
echo "安全测试完成!"