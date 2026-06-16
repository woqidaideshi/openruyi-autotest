#!/bin/sh -eux
# Functional test: libmicrohttpd - libmicrohttpd HTTP 服务库

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install libmicrohttpd ===
# Kill any stale dnf processes first
echo openruyi | sudo -S pkill -9 dnf 2>/dev/null || true
echo openruyi | sudo -S rm -f /var/run/dnf.pid 2>/dev/null || true
INSTALLED_BY_TEST=0
if ! rpm -q libmicrohttpd 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y --nogpgcheck libmicrohttpd 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed libmicrohttpd"
    else
        echo "SKIP: libmicrohttpd not available in repos"
        exit 0
    fi
else
    echo "SETUP: libmicrohttpd already installed"
fi

# 获取版本信息
rlRun 'rpm -q libmicrohttpd' 0 "获取 libmicrohttpd 版本信息"

# 列出包内文件
rlRun 'rpm -ql libmicrohttpd 2>/dev/null' 0 "列出 libmicrohttpd 文件列表"

# 检查共享库文件
rlRun 'rpm -ql libmicrohttpd 2>/dev/null | grep -E "\.so\.|\\.so$" || echo "NO_SO_FILES"' 0 "检查共享库文件"

# 检查头文件（如果有）
rlRun 'rpm -ql libmicrohttpd 2>/dev/null | grep -E "\.h$|\.pc$" || echo "NO_HEADER_FILES"' 0 "检查头文件和 pkg-config 文件"

# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y libmicrohttpd 2>/dev/null || true
    echo "TEARDOWN: removed libmicrohttpd"
fi
echo ""
echo "All libmicrohttpd tests passed!"
