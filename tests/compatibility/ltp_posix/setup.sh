#!/bin/sh -eux
# === SETUP: LTP POSIX 兼容性测试环境 ===
# 职责：安装编译依赖、clone LTP

LTP_DIR="/tmp/ltp-posix"
LTP_BUILD_DIR="$LTP_DIR/testcases/open_posix_testsuite"

# 如果已经设置完成，跳过
if [ "${LTP_SETUP_DONE:-0}" != "1" ]; then

SUDO_PASSWORD="openruyi"

INSTALLED_BY_TEST=0
DEPS="git gcc make"

# 检查并安装编译依赖
echo "=== SETUP: 检查编译依赖 ==="
MISSING_DEPS=""
for dep in $DEPS; do
    if ! rpm -q "$dep" 2>/dev/null; then
        MISSING_DEPS="$MISSING_DEPS $dep"
    fi
done

if [ -n "$MISSING_DEPS" ]; then
    echo "SETUP: 安装缺失依赖:$MISSING_DEPS"
    if echo "$SUDO_PASSWORD" | sudo -S dnf install -y $MISSING_DEPS 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: 依赖安装完成"
    else
        echo "SKIP: 无法安装编译依赖"
        exit 0
    fi
else
    echo "SETUP: 编译依赖已就绪"
fi

# Clone LTP（如果未 clone）
if [ ! -d "$LTP_DIR" ]; then
    echo "=== SETUP: Clone LTP 仓库 ==="
    git clone --depth 1 https://github.com/linux-test-project/ltp.git "$LTP_DIR"
else
    echo "SETUP: LTP 仓库已存在，使用缓存"
fi

# 导出环境变量
export LTP_DIR
export LTP_BUILD_DIR
export LTP_SETUP_DONE=1
export INSTALLED_BY_TEST

echo "SETUP: 环境就绪 LTP_BUILD_DIR=$LTP_BUILD_DIR"

fi  # LTP_SETUP_DONE guard
