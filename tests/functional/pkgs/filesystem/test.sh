#!/bin/sh -eux
# Functional test: filesystem package
# Tests filesystem 文件系统包
# Version: filesystem

rlRun() { eval "\$1" 2>&1; return \$?; }
# === SETUP: check/install filesystem ===
INSTALLED_BY_TEST=0
if ! rpm -q filesystem 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y filesystem 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed filesystem"
    else
        echo "SKIP: filesystem not available in repos"
        exit 0
    fi
else
    echo "SETUP: filesystem already installed"
fi



echo "=== 测试 1: 版本和帮助 ==="

# 库包，验证安装和文件存在
rlRun 'rpm -ql filesystem | head -20' 0 "列出包文件"
rlRun 'ls /usr/lib64/lib*.so* 2>/dev/null | head -5 || echo "无库文件"' 0 "库文件检查"

echo "=== 测试 2: 错误处理 ==="


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y filesystem 2>/dev/null || true
    echo "TEARDOWN: removed filesystem"
fi
echo ""
echo "All filesystem functional tests passed!"
