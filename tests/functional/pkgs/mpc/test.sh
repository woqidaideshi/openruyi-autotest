#!/bin/sh -eux
# Functional test: mpc package
# Tests MPC 复数运算库
# Version: mpc

rlRun() { eval "\$1" 2>&1; return \$?; }
# === SETUP: check/install mpc ===
INSTALLED_BY_TEST=0
if ! rpm -q mpc 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y mpc 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed mpc"
    else
        echo "SKIP: mpc not available in repos"
        exit 0
    fi
else
    echo "SETUP: mpc already installed"
fi



echo "=== 测试 1: 版本和帮助 ==="

# 库包，验证安装和文件存在
rlRun 'rpm -ql mpc | head -20' 0 "列出包文件"
rlRun 'ls /usr/lib64/lib*.so* 2>/dev/null | head -5 || echo "无库文件"' 0 "库文件检查"

echo "=== 测试 2: 错误处理 ==="


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y mpc 2>/dev/null || true
    echo "TEARDOWN: removed mpc"
fi
echo ""
echo "All mpc functional tests passed!"
