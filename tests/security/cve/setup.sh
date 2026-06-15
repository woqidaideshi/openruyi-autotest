#!/bin/sh -eu
# LTP CVE 测试套件 - Setup
# 按照 LTP 官方文档安装 ltp-tests

LTP_DIR="/opt/ltp"

echo "=== LTP CVE Setup ==="

# 如果已安装则跳过
if [ -f "$LTP_DIR/runltp" ]; then
    echo "LTP already installed at $LTP_DIR"
    exit 0
fi

# 方式1: 尝试通过系统包管理器安装
if command -v dnf >/dev/null 2>&1; then
    echo "Installing LTP via dnf..."
    sudo dnf install -y ltp 2>/dev/null && echo "LTP installed via dnf" && exit 0
    echo "dnf install failed, trying from source..."
fi

# 方式2: 从源码编译
echo "Building LTP from source..."
cd /tmp
rm -rf ltp
git clone --depth 1 https://github.com/linux-test-project/ltp.git 2>/dev/null || {
    echo "Git clone failed, LTP setup incomplete"
    exit 1
}
cd ltp
make autotools 2>/dev/null || true
./configure --prefix="$LTP_DIR" 2>/dev/null || {
    echo "LTP configure failed"
    exit 1
}
make -j$(nproc) 2>/dev/null || make
sudo make install 2>/dev/null || {
    echo "LTP make install failed"
    exit 1
}
cd /tmp
rm -rf ltp
echo "LTP installed at $LTP_DIR"
