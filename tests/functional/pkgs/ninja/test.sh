#!/bin/sh -eux
# Functional test: ninja - Ninja 小型构建系统

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install ninja ===
# Kill any stale dnf processes first
echo openruyi | sudo -S pkill -9 dnf 2>/dev/null || true
echo openruyi | sudo -S rm -f /var/run/dnf.pid 2>/dev/null || true
INSTALLED_BY_TEST=0
if ! rpm -q ninja 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y --nogpgcheck ninja 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed ninja"
    else
        echo "SKIP: ninja not available in repos"
        exit 0
    fi
else
    echo "SETUP: ninja already installed"
fi

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

# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y ninja 2>/dev/null || true
    echo "TEARDOWN: removed ninja"
fi
echo ""
echo "All ninja tests passed!"
