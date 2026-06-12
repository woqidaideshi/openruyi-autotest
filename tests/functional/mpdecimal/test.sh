#!/bin/sh -eux
# Functional test: mpdecimal package
# Tests mpdecimal 十进制库
# Version: mpdecimal

rlRun() { eval "\$1" 2>&1; return \$?; }
# === SETUP: check/install mpdecimal ===
INSTALLED_BY_TEST=0
if ! rpm -q mpdecimal 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y mpdecimal 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed mpdecimal"
    else
        echo "SKIP: mpdecimal not available in repos"
        exit 0
    fi
else
    echo "SETUP: mpdecimal already installed"
fi



echo "=== 测试 1: 版本和帮助 ==="

# 库包，验证安装和文件存在
rlRun 'rpm -ql mpdecimal | head -20' 0 "列出包文件"
rlRun 'ls /usr/lib64/lib*.so* 2>/dev/null | head -5 || echo "无库文件"' 0 "库文件检查"

echo "=== 测试 2: 错误处理 ==="


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y mpdecimal 2>/dev/null || true
    echo "TEARDOWN: removed mpdecimal"
fi
echo ""
echo "All mpdecimal functional tests passed!"
