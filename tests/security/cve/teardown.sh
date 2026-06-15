#!/bin/sh -eu
# LTP CVE 测试套件 - Teardown
# 清除 LTP 测试环境

LTP_DIR="/opt/ltp"

echo "=== LTP CVE Teardown ==="

if [ -d "$LTP_DIR" ]; then
    echo "Removing LTP installation at $LTP_DIR..."
    sudo rm -rf "$LTP_DIR"
fi

# 清理临时文件
sudo rm -rf /tmp/ltp 2>/dev/null || true

echo "LTP CVE environment cleaned"
