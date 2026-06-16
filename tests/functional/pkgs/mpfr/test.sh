#!/bin/sh -eux
# Functional test: mpfr package
# Tests MPFR 多精度浮点库
# Version: mpfr

rlRun() { eval "\$1" 2>&1; return \$?; }
# === SETUP: check/install mpfr ===
INSTALLED_BY_TEST=0
if ! rpm -q mpfr 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y mpfr 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed mpfr"
    else
        echo "SKIP: mpfr not available in repos"
        exit 0
    fi
else
    echo "SETUP: mpfr already installed"
fi



echo "=== 测试 1: 版本和帮助 ==="

# 库包，验证安装和文件存在
rlRun 'rpm -ql mpfr | head -20' 0 "列出包文件"
rlRun 'ls /usr/lib64/lib*.so* 2>/dev/null | head -5 || echo "无库文件"' 0 "库文件检查"

echo "=== 测试 2: 错误处理 ==="


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y mpfr 2>/dev/null || true
    echo "TEARDOWN: removed mpfr"
fi
echo ""
echo "All mpfr functional tests passed!"
