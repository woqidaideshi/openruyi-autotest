#!/bin/sh -eux
# === TEARDOWN: LTP POSIX 兼容性测试清理 ===
# 职责：清理临时目录、卸载 setup 安装的依赖

echo "=== TEARDOWN: 清理 LTP 测试环境 ==="

# 清理临时目录
if [ -d "/tmp/ltp-posix" ]; then
    rm -rf /tmp/ltp-posix
    echo "TEARDOWN: 已清理 /tmp/ltp-posix"
fi

# 卸载 setup 安装的依赖
if [ "${INSTALLED_BY_TEST:-0}" = "1" ]; then
    echo "TEARDOWN: 卸载测试安装的编译依赖..."
    echo "$SUDO_PASSWORD" | sudo -S dnf remove -y git gcc make autoconf automake m4 2>/dev/null || true
    echo "TEARDOWN: 依赖卸载完成"
fi

echo "TEARDOWN: 清理完成"
