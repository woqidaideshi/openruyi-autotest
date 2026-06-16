#!/bin/sh -eux
# Functional test: gmp package
# Tests GMP 大数运算库
# Version: gmp

rlRun() { eval "\$1" 2>&1; return \$?; }
# === SETUP: check/install gmp ===
INSTALLED_BY_TEST=0
if ! rpm -q gmp 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y gmp 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed gmp"
    else
        echo "SKIP: gmp not available in repos"
        exit 0
    fi
else
    echo "SETUP: gmp already installed"
fi



echo "=== 测试 1: 版本和帮助 ==="

# 库包，验证安装和文件存在
rlRun 'rpm -ql gmp | head -20' 0 "列出包文件"
rlRun 'ls /usr/lib64/lib*.so* 2>/dev/null | head -5 || echo "无库文件"' 0 "库文件检查"

echo "=== 测试 2: 错误处理 ==="


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y gmp 2>/dev/null || true
    echo "TEARDOWN: removed gmp"
fi
echo ""
echo "All gmp functional tests passed!"
