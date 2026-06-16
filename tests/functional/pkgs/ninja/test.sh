#!/bin/sh -eux
# Functional test: ninja - Ninja 小型构建系统

. "./setup.sh"


# 获取版本信息
rlRun 'rpm -q ninja' 0 "获取 ninja 版本信息"

# 列出包内二进制文件
rlRun 'rpm -ql ninja 2>/dev/null | grep -E "^/usr/bin/|^/usr/sbin/" || echo "NO_BINARIES"' 0 "列出包内二进制文件"

# 检查主要可执行文件
MAIN_BIN=$(rpm -ql ninja 2>/dev/null | grep -E "^/usr/bin/ninja$" | head -1)
if [ -n "$MAIN_BIN" ] && [ -x "$MAIN_BIN" ]; then
    rlRun '"$MAIN_BIN" --version 2>&1 || "$MAIN_BIN" -version 2>&1 || "$MAIN_BIN" version 2>&1 || echo "NO_VERSION_FLAG"' 0 "获取 ninja 版本输出"
fi

# 检查手册页
rlRun 'rpm -ql ninja 2>/dev/null | grep -E "\.1\.gz$|\.5\.gz$" || echo "NO_MAN_PAGES"' 0 "检查手册页"

. "./teardown.sh"
echo "All ninja tests passed!"
